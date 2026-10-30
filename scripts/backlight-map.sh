#!/bin/bash
# Печатает JSON-карту { "DP-1": "ddcci4", ... } для виджета яркости eww.
#
# Сопоставление не завязано на конкретные модели/бренды:
#   1) по idModel/idSerial устройства подсветки (быстро, без DDC-запросов);
#   2) если модели неоднозначны (одинаковые мониторы) — точно, через
#      DRM-коннектор -> i2c-шина (`ddcutil detect`);
#   3) для ноутбука: единственный монитор и единственная подсветка.
#
# Результат кешируется в /run/user/<uid> и пересчитывается только когда
# меняется набор мониторов или устройств подсветки.
set -u

shopt -s nullglob

cache_dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
cache="$cache_dir/eww-backlight-map.cache"

monitors=$(hyprctl monitors -j 2>/dev/null) || monitors='[]'

bls=()
for dev in /sys/class/backlight/*; do
    [[ -e "$dev" ]] || continue
    bls+=("$(basename "$dev")")
done

mon_sig=$(jq -c '[.[] | {name, model, serial, description}]' <<<"$monitors" 2>/dev/null || printf '[]')
bl_sig=$( ((${#bls[@]})) && printf '%s\n' "${bls[@]}" | sort | paste -sd, || true)
sig=$(printf '%s|%s' "$mon_sig" "$bl_sig" | sha256sum | cut -d' ' -f1)

if [[ -r $cache ]]; then
    { read -r cached_sig; read -r cached_json; read -r cached_ts; read -r cached_ttl; } <"$cache"
    if [[ $cached_sig == "$sig" && -n ${cached_json:-} && -n ${cached_ttl:-} ]] &&
        (( cached_ttl == 0 || $(date +%s) - cached_ts < cached_ttl )); then
        printf '%s\n' "$cached_json"
        exit 0
    fi
fi

names=()
models=()
serials=()
matches=()
while IFS=$'\t' read -r n m s; do
    [[ -n $n ]] || continue
    names+=("$n")
    models+=("$m")
    serials+=("$s")
    matches+=("")
done < <(jq -r '.[] | [.name, .model, (.serial // "")] | @tsv' <<<"$monitors" 2>/dev/null)

declare -A used=()

# 1) по модели и серийнику, только если кандидат однозначен
for i in "${!names[@]}"; do
    cands=()
    for dev in "${bls[@]}"; do
        [[ -n ${used[$dev]-} ]] && continue
        dm=$(cat "/sys/class/backlight/$dev/device/idModel" 2>/dev/null || true)
        ds=$(cat "/sys/class/backlight/$dev/device/idSerial" 2>/dev/null || true)
        [[ -n $dm ]] || continue
        if [[ ${models[$i]} == *"$dm"* || $dm == *"${models[$i]}"* ]]; then
            if [[ -n ${serials[$i]} && ${serials[$i]} != "0" && -n $ds && $ds != "0" && $ds != "${serials[$i]}" ]]; then
                continue
            fi
            cands+=("$dev")
        fi
    done
    if ((${#cands[@]} == 1)); then
        matches[$i]=${cands[0]}
        used[${cands[0]}]=1
    fi
done

# 2) точное сопоставление через DRM connector -> i2c bus
need_ddcutil=0
for m in "${matches[@]}"; do
    [[ -z $m ]] && need_ddcutil=1
done

if ((need_ddcutil)) && command -v ddcutil >/dev/null 2>&1; then
    declare -A bus_by_conn=()
    while IFS='|' read -r bus conn; do
        [[ -n $bus && -n $conn ]] && bus_by_conn["$conn"]=$bus
    done < <(ddcutil detect --brief --sleep-multiplier 0.2 2>/dev/null | awk '
        /I2C bus:/ {
            for (i = 1; i <= NF; i++)
                if ($i ~ /^\/dev\/i2c-/) { bus = $i; sub(/.*i2c-/, "", bus) }
        }
        /DRM connector:/ {
            conn = $NF
            sub(/^card[0-9]+-/, "", conn)
            if (bus != "") { print bus "|" conn; bus = "" }
        }')

    for i in "${!names[@]}"; do
        [[ -n ${matches[$i]} ]] && continue
        bus=${bus_by_conn[${names[$i]}]-}
        [[ -n $bus ]] || continue
        if [[ -d /sys/class/backlight/ddcci$bus ]]; then
            matches[$i]="ddcci$bus"
            used["ddcci$bus"]=1
        elif ddcutil getvcp 10 --bus "$bus" --sleep-multiplier 0.2 >/dev/null 2>&1; then
            # ddcci не смог прицепиться (кривой DDC/CI-ответ), но яркость
            # через ddcutil работает — используем его напрямую
            matches[$i]="ddcutil:$bus"
        fi
    done
fi

out=""
for i in "${!names[@]}"; do
    [[ -n ${matches[$i]} ]] && out+=$(printf '"%s":"%s",' "${names[$i]}" "${matches[$i]}")
done

# 3) ноутбук: один монитор и одна подсветка
mon_count=$(jq 'length' <<<"$monitors" 2>/dev/null || echo 0)
if [[ -z $out && $mon_count -eq 1 && ${#bls[@]} -eq 1 ]]; then
    out=$(printf '"%s":"%s",' "${names[0]}" "${bls[0]}")
fi

json=$(printf '{%s}' "${out%,}")

# Если внешний монитор остался без backend'а (спит при загрузке, ещё не
# ответил на DDC/CI), кешируем результат ненадолго: через 15 секунд
# пересчитаем и подхватим его, когда он проснётся. Внутренние панели
# (eDP/LVDS/DSI) DDC/CI не имеют — для них кеш обычный.
unresolved=0
for i in "${!names[@]}"; do
    [[ -n ${matches[$i]} ]] && continue
    case ${names[$i]} in
        eDP-* | LVDS-* | DSI-* | DPI-*) continue ;;
    esac
    unresolved=1
done
ttl=0
((unresolved)) && ttl=15

mkdir -p "$cache_dir" 2>/dev/null &&
    printf '%s\n%s\n%s\n%s\n' "$sig" "$json" "$(date +%s)" "$ttl" >"$cache" 2>/dev/null || true

printf '%s\n' "$json"
