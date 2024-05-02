#!/bin/sh

while true; do
    read -p "Dotfiles on desktop(yes) or on laptop(no)? : " yn
    case $yn in
        [Yy]* ) 
            stow bspwm chromium clang-format clangd git kitty nvim picom polybar ranger sxhkd wallpapers x zathura zsh zshrc;
            sudo stow -t /etc/X11/xorg.conf.d/ keyboardLayout;
            echo "done";
            break;;
        [Nn]* ) 
            stow bspwm chromium clang-format clangd git kitty nvim picom polybar ranger sxhkd wallpapers x zathura zsh zshrc xmodmap;
            sudo stow -t /etc/X11/xorg.conf.d/ keyboardLayout;
            echo "done";
            exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

