#!/bin/sh

setxkbmap -model pc105 -layout us,ru -option grp:caps_toggle

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# xset r rate 300 50
# xsetroot -cursor_name left_ptr
# [ -f ~/.xprofile ] && . ~/.xprofile

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xset r rate 300 50
xsetroot -cursor_name left_ptr
picom &

if [ -x "$(command -v nvidia-settings)" ]; then
    nvidia-settings --load-config-only &
    gwe --hide-window &     # регулировка вентиляторов видеокарты
fi

udiskie &               # автоподключение флешек
nitrogen --restore      # обои
dex --autostart &
spoofdpi > /dev/null &
exec bspwm              # оконный менеджер
