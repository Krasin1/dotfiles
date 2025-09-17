#!/bin/sh

case $1 in
    get)
        brillo -l -eG | jq -R -n ' [inputs | split("\t") | {key: .[0], value: .[1] | tonumber | floor}] | from_entries' 
        ;;
    up|down|max|min)
        case $1 in
            up) param="-A 5" ;;
            down) param="-U 5" ;;
            max) param="-S 100" ;;
            min) param="-S 0" ;;
        esac

        if [ -z "$2" ]; then
            brillo -ql $param
        else
            brillo -ql -s "$2" $param
        fi
        ;;
esac
