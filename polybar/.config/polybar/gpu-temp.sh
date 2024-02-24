#!/bin/sh
temp="$(nvidia-smi -q -d temperature | awk 'NR==11{print $5}')"
echo -e "$temp°C"
