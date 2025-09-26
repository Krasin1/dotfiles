#!/bin/sh

function handle {
  if [[ ${1:0:12} == "monitoradded" ]]; then
    ~/.config/eww/launch_bar
  elif [[ ${1:0:14} == "monitorremoved" ]]; then
    ~/.config/eww/launch_bar
  fi
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done
