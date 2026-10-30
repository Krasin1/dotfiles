#!/bin/bash
# Управление яркостью мониторов.
#
# Backend'ы (значения приходят из scripts/backlight-map.sh):
#   ddcciN        — /sys/class/backlight/ddcciN, запись напрямую через sysfs;
#   ddcutil:<bus> — монитор, к которому ddcci не смог прицепиться (кривой
#                   DDC/CI-ответ), но яркость доступна через ddcutil.
#
# Значения везде в процентах 0..100.
#
# Любая DDC-запись (sysfs ddcci или ddcutil) занимает десятки-сотни мс,
# поэтому виджет не ждёт её: целевое значение сразу уходит в eww, а в монитор
# его пишет фоновый worker. Серия событий быстрого скролла склеивается в одну
# запись последнего значения, уведомление тоже показывается один раз.

set -u

DIR="$HOME/.config/dunst/icons"
BRIGHTNESS_STEPS=5
BACKLIGHT_DIR=/sys/class/backlight
STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/eww-brightness"
# Меньше задержек между командами ddcutil (по умолчанию он спит слишком много).
DDCUTIL_ARGS=(--sleep-multiplier 0.2)

safe_name() { printf '%s' "$1" | tr ':' '_'; }
state_path() { printf '%s/%s.%s' "$STATE_DIR" "$(safe_name "$1")" "$2"; }

mkdir -p "$STATE_DIR" 2>/dev/null || true

# Один DDC-разговор на шину: worker и опрос не мешают друг другу.
bus_lock() {
    local bus=$1
    shift
    flock -w 5 "$STATE_DIR/bus-$bus.lock" "$@"
}

get_value() {
    local be=$1
    case $be in
        ddcutil:*)
            local bus=${be#ddcutil:} cur max
            read -r cur max < <(
                bus_lock "$bus" ddcutil getvcp 10 --bus "$bus" "${DDCUTIL_ARGS[@]}" 2>/dev/null |
                    sed -n 's/.*current value = *\([0-9][0-9]*\), max value = *\([0-9][0-9]*\).*/\1 \2/p'
            )
            [[ -n ${cur:-} && -n ${max:-} && $max -gt 0 ]] || return 1
            echo $(( cur * 100 / max ))
            ;;
        *)
            local cur max
            cur=$(cat "$BACKLIGHT_DIR/$be/brightness" 2>/dev/null) || return 1
            max=$(cat "$BACKLIGHT_DIR/$be/max_brightness" 2>/dev/null) || return 1
            [[ $max -gt 0 ]] || return 1
            echo $(( cur * 100 / max ))
            ;;
    esac
}

set_value() {
    local be=$1 val=$2
    case $be in
        ddcutil:*)
            local bus=${be#ddcutil:}
            # --noverify: не тратим ещё один DDC-раунд на чтение после записи
            bus_lock "$bus" ddcutil setvcp 10 "$val" --bus "$bus" \
                "${DDCUTIL_ARGS[@]}" --noverify >/dev/null 2>&1
            ;;
        *)
            local max raw
            max=$(cat "$BACKLIGHT_DIR/$be/max_brightness" 2>/dev/null) || return 1
            [[ $max -gt 0 ]] || return 1
            raw=$(( val * max / 100 ))
            (( raw > max )) && raw=$max
            if ! { echo "$raw" > "$BACKLIGHT_DIR/$be/brightness"; } 2>/dev/null; then
                brillo -q -s "$be" -S "$raw" >/dev/null 2>&1 || return 1
            fi
            ;;
    esac
}

monitor_name() {
    local be=$1 map name
    # Обычно карта уже есть в eww — не запускаем лишний скрипт.
    map=$(eww get backlight_map 2>/dev/null) || map=""
    if [[ -z $map ]]; then
        map=$("$HOME/dotfiles/scripts/backlight-map.sh" 2>/dev/null) || { echo "$be"; return; }
    fi
    name=$(jq -r --arg be "$be" 'to_entries[] | select(.value == $be) | .key' \
        <<<"$map" 2>/dev/null | head -n1)
    echo "${name:-$be}"
}

# Подпись для уведомления: модель монитора и коннектор, например
# "DELL P2214H (DP-1)". Если Hyprland не знает коннектор (или mon — это
# backend), остаётся только то, что удалось выяснить.
monitor_label() {
    local be=$1 mon=${2:-} model
    [[ -n $mon ]] || mon=$(monitor_name "$be")
    model=$(hyprctl monitors -j 2>/dev/null |
        jq -r --arg n "$mon" '.[] | select(.name == $n) | .model // empty' 2>/dev/null |
        head -n1)
    if [[ -n $model ]]; then
        printf '%s (%s)' "$model" "$mon"
    else
        printf '%s' "$mon"
    fi
}

send_notification() {
    local be=$1 val=$2 mon=${3:-} id
    mon=$(monitor_label "$be" "$mon")
    # Стабильный id на монитор: новые значения заменяют прошлое уведомление.
    id=$(printf '%s' "$be" | cksum | awk '{print 5000 + ($1 % 1000)}')
    dunstify -r "$id" -t 2000 -u low -h "int:value:$val" \
        "Brightness $val%" "$mon" -i "$DIR/brightness.svg" >/dev/null 2>&1 || true
}

# Обновляем переменную eww сразу, чтобы ползунок не ждал следующего опроса.
eww_update() {
    local be=$1 val=$2 cur new
    command -v eww >/dev/null 2>&1 || return 0
    cur=$(eww get brightness 2>/dev/null) || return 0
    new=$(jq -c --arg k "$be" --argjson v "$val" \
        'if type == "object" then .[$k] = $v else {($k): $v} end' \
        <<<"$cur" 2>/dev/null) || return 0
    eww update brightness="$new" >/dev/null 2>&1 || true
}

# Последнее известное значение из eww: во время скролла не нужно каждый раз
# заново читать монитор (для ddcutil это лишние ~0.3 с).
cached_value() {
    local be=$1 cur
    command -v eww >/dev/null 2>&1 || return 1
    cur=$(eww get brightness 2>/dev/null) || return 1
    jq -er --arg k "$be" '.[$k] | numbers' <<<"$cur" 2>/dev/null
}

# Значение, которое уже запрошено, но ещё не применено worker'ом.
pending_value() {
    local be=$1 target last
    target=$(cat "$(state_path "$be" target)" 2>/dev/null) || return 1
    last=$(cat "$(state_path "$be" last)" 2>/dev/null) || return 1
    [[ -n $target && $target != "$last" ]] || return 1
    printf '%s\n' "$target"
}

# Все доступные backend'ы: sysfs-подсветки + ddcutil-мониторы из карты.
all_backends() {
    local d b map
    local -A seen=()
    shopt -s nullglob
    for d in "$BACKLIGHT_DIR"/*; do
        [[ -e $d ]] && seen[$(basename "$d")]=1
    done
    map=$("$HOME/dotfiles/scripts/backlight-map.sh" 2>/dev/null) || map='{}'
    while IFS= read -r b; do
        [[ $b == ddcutil:* ]] && seen[$b]=1
    done < <(jq -r '.[]?' <<<"$map" 2>/dev/null)
    printf '%s\n' "${!seen[@]}" | sort
}

# Вычисляет целевое значение для up/down/max/min.
target_value() {
    local be=$1 cmd=$2 cur val
    case $cmd in
        up|down)
            cur=$(cached_value "$be") || cur=$(get_value "$be") || return 1
            if [[ $cmd == up ]]; then
                val=$((cur + BRIGHTNESS_STEPS))
            else
                val=$((cur - BRIGHTNESS_STEPS))
            fi
            ;;
        max) val=100 ;;
        min) val=0 ;;
    esac
    (( val < 0 )) && val=0
    (( val > 100 )) && val=100
    printf '%s\n' "$val"
}

# Фоновый worker: применяет последнее запрошенное значение и сам выходит.
# Блокировка ждёт, а не отбрасывает задание; повторную запись того же
# значения отсекает файл last, поэтому серия скролла = одна запись в монитор.
apply_worker() {
    local be=$1 mon=${2:-} f last_f target last applied=""
    f=$(state_path "$be" target)
    last_f=$(state_path "$be" last)
    exec 9>"$(state_path "$be" apply.lock)" || exit 0
    flock -w 10 9 || exit 0

    while :; do
        target=$(cat "$f" 2>/dev/null) || break
        [[ -n $target ]] || break
        last=$(cat "$last_f" 2>/dev/null) || last=""
        [[ $target == "$last" ]] && break
        if ! set_value "$be" "$target"; then
            # запись не удалась (монитор спит/нет DDC) — не врём в уведомлении,
            # просто снимаем pending, опрос покажет фактическое значение
            printf '%s\n' "$target" >"$last_f" 2>/dev/null
            applied=""
            break
        fi
        printf '%s\n' "$target" >"$last_f" 2>/dev/null || true
        applied=$target
    done

    # Уведомление — один раз на итоговое значение, а не на каждый тик скролла.
    [[ -n $applied ]] || exit 0
    send_notification "$be" "$applied" "$mon"
}

# Записываем цель и запускаем worker (он сам разберётся с очередью).
queue_value() {
    local be=$1 val=$2 mon=${3:-}
    printf '%s\n' "$val" >"$(state_path "$be" target)"
    if command -v setsid >/dev/null 2>&1; then
        setsid "$0" _apply "$be" "$mon" >/dev/null 2>&1 &
    else
        "$0" _apply "$be" "$mon" </dev/null >/dev/null 2>&1 &
    fi
}

cmd=${1:-}
case $cmd in
    _apply)
        apply_worker "${2:?backend required}" "${3:-}"
        ;;
    get)
        out=""
        while IFS= read -r be; do
            [[ -n $be ]] || continue
            # пока запись ещё не применилась, показываем запрошенное значение,
            # чтобы опрос не откатывал ползунок назад
            val=$(pending_value "$be") || val=$(get_value "$be") || continue
            out+=$(printf '"%s":%s,' "$be" "$val")
        done < <(all_backends)
        printf '{%s}\n' "${out%,}"
        ;;
    up|down|max|min)
        shift
        mon=${2:-}
        targets=()
        if (($# > 0)); then
            targets=("$1")
        else
            mapfile -t targets < <(all_backends)
        fi

        for be in "${targets[@]}"; do
            [[ -n $be ]] || continue
            # Сериализуем "прочитать текущее -> записать цель": события
            # скролла приходят параллельно и иначе терялись бы.
            exec 8>"$(state_path "$be" state.lock)"
            flock 8
            if val=$(target_value "$be" "$cmd"); then
                eww_update "$be" "$val"
                queue_value "$be" "$val" "$mon"
            fi
            flock -u 8
            exec 8>&-
        done
        ;;
esac
