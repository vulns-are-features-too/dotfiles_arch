#!/bin/zsh

export HISTFILE=~/.cache/zsh/history
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILESIZE=10000

source ~/.profile

# startx if tty1
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx
