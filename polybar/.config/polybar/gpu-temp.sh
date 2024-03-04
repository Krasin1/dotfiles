#!/bin/sh
if command -v nvidia-smi &> /dev/null; then
    temp="$(nvidia-smi -q -d temperature | awk 'NR==11{print $5}')"
    echo -e "$temp°C"
else
    echo ""; exit 0;
fi
