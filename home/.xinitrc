#!/bin/bash

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Disable "screen off after some time idle"
xset -dpms
xset s off

# Applications to run
numlockx on
pgrep clipmenud || clipmenud &
pgrep dunst || dunst &
pgrep unclutter || unclutter --ignore-scrolling --jitter 5 &
#pgrep nm-applet || nm-applet &
#pgrep blueman-applet || blueman-applet &
pgrep flameshot || flameshot &
pgrep transmission-daemon || transmission-daemon -er -t &
pgrep lxpolkit || lxpolkit &
xss-lock -q -- i3lock -c 000000 &

# Start window manager
bspwm -c ~/.config/bspwm/bspwmrc
