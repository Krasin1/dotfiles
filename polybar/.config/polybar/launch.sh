#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Cpu temp path
for i in /sys/class/hwmon/hwmon*/temp*_input; do 
    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "coretemp: Package id 0" ]; then
        export HWMON_PATH="$i"
    fi

    if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "amdgpu: edge" ]; then
        export HWMON_PATH="$i"
    fi
    
    # if [ "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*}))" = "k10temp: Tctl" ]; then
    #     export HWMON_PATH="$i"
    # fi
done

for mon in $(polybar --list-monitors | cut -d":" -f1); do
    (MONITOR=$mon polybar -q pam1 -c ~/.config/polybar/config.ini) &
    (MONITOR=$mon polybar -q pam2 -c ~/.config/polybar/config.ini) &
    (MONITOR=$mon polybar -q pam3 -c ~/.config/polybar/config.ini) &
    (MONITOR=$mon polybar -q pam4 -c ~/.config/polybar/config.ini) &
    (MONITOR=$mon polybar -q pam5 -c ~/.config/polybar/config.ini) &
    (MONITOR=$mon polybar -q pam6 -c ~/.config/polybar/config.ini) &
done


