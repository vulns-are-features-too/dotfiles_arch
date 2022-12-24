#!/bin/bash

# PATHs
export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/library/"
export GOPATH="$HOME/.go"
export PERL5LIB="/home/jco/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="/home/jco/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"/home/jco/perl5\""
export PERL_MM_OPT="INSTALL_BASE=/home/jco/perl5"
export LIBVA_DRIVER_NAME=vdpau
export JAVA_HOME=/usr/lib/jvm/default
PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.npm/bin:/usr/bin/vendor_perl:$GOPATH/bin:$HOME/perl5/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
PATH="$HOME/git/scripts:$(fd . -t d "$HOME/git/scripts" | tr '\n' ':' | sed 's/:*$//'):$PATH"
export PATH

# Default applications
export BROWSER="firefox"
export EDITOR="nvim"
export FILE_CLI="vifm"
export FILE_GUI="pcmanfm"
export TERMINAL="alacritty"

# building
export RUSTC_WRAPPER='/usr/bin/sccache'

# bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# less
export LESS="$LESS -R"
export LESSOPEN="|/usr/bin/lesspipe.sh %s"

# exa
export TIME_STYLE=long-iso

# zoxide
export _ZO_RESOLVE_SYMLINKS=1

# Increase batch limit
ulimit -n 40000

# Start ssh agent
eval "$(ssh-agent -s)" &> /dev/null
[ -f ~/.ssh/github ] && ssh-add -q ~/.ssh/github

# GPG
export GPG_TTY="$(tty)"
