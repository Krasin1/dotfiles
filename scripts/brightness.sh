#!/bin/sh

DIR="$HOME/.config/dunst/icons"
BRIGHTNESS_STEPS=5

function get_brightness {
    if [ -z "$1" ]; then
        brillo -lG | awk '{print int($1)}'
    else
        brillo -l -s "$1" | awk '{print int($1)}'
    fi
}

function send_notification {
    icon="$DIR/brightness.svg"
    brightness=$(get_brightness $1)
    # Send the notification
    dunstify "Brightness $brightness%" "$1" -i $icon -t 1000 -r 5555 -u low -h int:value:$(($brightness))
}

case $1 in
    get)
        brillo -l -eG | jq -R -n ' [inputs | split("\t") | {key: .[0], value: .[1] | tonumber | floor}] | from_entries' 
        ;;
    up|down|max|min)
        case $1 in
            up) param="-A $BRIGHTNESS_STEPS" ;;
            down) param="-U $BRIGHTNESS_STEPS" ;;
            max) param="-S 100" ;;
            min) param="-S 0" ;;
        esac

        if [ -z "$2" ]; then
            brillo -ql $param
        else
            brillo -ql -s "$2" $param
        fi

        send_notification $2
        ;;
esac

