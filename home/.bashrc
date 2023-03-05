#!/bin/bash
# ~/.bashrc

[[ $- != *i* ]] && return

COMPLETION_DIR="$HOME/git/dotfiles/shells/bash/completions"

source "$HOME/git/dotfiles/shells/shared.sh"

# Disables Ctrl-S which freezes the terminal
bind -r '\C-s'
stty -ixon

# Enable history appending instead of overwriting
shopt -s histappend

# Custom prompt
PS1="\[\033[32m\][\w] \[\033[31m\]\$\[\033[00m\] "

# Vim mode
set -o vi

# zoxide
eval "$(zoxide init --cmd 'j' --hook 'pwd' bash)"

# Completion
for i in "$COMPLETION_DIR"/*; do
  source "$i"
done
__git_complete g __git_main

# just
complete -F _just -o bashdefault -o default jj

eval "$(starship init bash)"


# broot
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        command rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        command rm -f "$cmd_file"
        return "$code"
    fi
}
