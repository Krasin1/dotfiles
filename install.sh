#!/bin/sh

while true; do
    read -p "Install keyboard and touchpad settings? : " yn
    case $yn in
        [Yy]* ) 
            # stow bspwm chromium clang-format clangd git kitty nvim picom polybar ranger sxhkd wallpapers x zathura zsh zshrc rofi xmodmap;
            sudo stow -t /etc/X11/xorg.conf.d/ keyboardLayout;
            sudo stow -t /etc/X11/xorg.conf.d/ touchpad;
            echo "done";
            break;;
        [Nn]* ) 
            echo "exit"
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

