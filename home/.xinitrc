#!/bin/bash

# `setxkbmap` resets `xmodmap`
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Disable "screen off after some time idle"
xset -dpms
xset s off

# Applications to run
numlockx on
pgrep dunst || dunst &
pgrep unclutter || unclutter --ignore-scrolling --jitter 5 &
#pgrep nm-applet || nm-applet &
#pgrep blueman-applet || blueman-applet &
pgrep flameshot || flameshot &
pgrep transmission-daemon || transmission-daemon -er -t &
pgrep lxpolkit || lxpolkit &

# screenlock: dim after 10min inactive, then lock after another 1min
xset s 600 60
xss-lock -n dim-screen -- lock-screen &

# last if block from /etc/X11/xinit/xinitrc
xinitdir=/etc/X11/xinit
if [ -d $xinitdir/xinitrc.d ] ; then
 for f in "$xinitdir/xinitrc.d"/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Start window manager
bspwm -c ~/.config/bspwm/bspwmrc
