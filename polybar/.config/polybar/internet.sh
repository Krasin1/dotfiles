#!/bin/sh

# Test for network conection
for interface in $(ls /sys/class/net/ | grep -vw -e "lo" -e "ham.");
do
  if [[ $(cat /sys/class/net/$interface/carrier) = 1 ]]; then OnLine=1; fi
done
if ! [ $OnLine ]; then
    echo "%{A1:kitty -e nmtui:}%{T2}󰪎%{T-}%{A}"; exit; 
else 
    echo ""; exit 0; 
fi

# 󱘖
# 󱘖
# 󰪎
# 󰖟
# 󱚿
# 
# 󰤭

