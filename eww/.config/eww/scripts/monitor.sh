#!/bin/bash

pidfile="/tmp/eww-monitor-handler.pid"

# Если PID-файл существует и процесс живой → ничего не делаем
if [[ -f "$pidfile" ]]; then
    oldpid=$(cat "$pidfile")
    if ps -p "$oldpid" -o comm= | grep -q "^monitor.sh$"; then
        echo "Monitor.sh уже запущен (PID $oldpid), выходим"
        exit 0
    fi
fi
# Записываем новый PID
echo $$ > "$pidfile"

cleanup() { rm -f /tmp/eww-monitor-handler.pid; }
trap cleanup EXIT

function handle {
  if [[ ${1:0:12} == "monitoradded" ]]; then
    ~/.config/eww/launch_bar
  elif [[ ${1:0:14} == "monitorremoved" ]]; then
    ~/.config/eww/launch_bar
  fi
}

socat -U - UNIX-CONNECT:$(echo $XDG_RUNTIME_DIR)/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done
