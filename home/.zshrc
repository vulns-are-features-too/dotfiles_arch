#!/bin/zsh

COMPLETION_DIR="$HOME/git/dotfiles/shells/zsh/completions"
PLUGIN_DIR="$HOME/git/dotfiles/shells/zsh/plugins"

source ~/git/dotfiles/shells/shared.sh

setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt nocheckjobs
setopt numericglobsort
setopt nobeep
setopt appendhistory
setopt histignorealldups
setopt NO_autoparamslash

unalias run-help
autoload -Uz run-help
alias help=run-help

# Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
for i in $(ls $PLUGIN_DIR); do
  source $PLUGIN_DIR/$i
done

unset _comp_dumpfile ZDOTDIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME
# Completion
fpath=($fpath /usr/share/zsh/functions/Completion/* $COMPLETION_DIR)
zstyle ':autocomplete:*' ignored-input 'yta##'
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' recent-dirs
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':completion:*' extra-verbose yes
zstyle ':completion:*:complete:*:' group-order files executables local-directories options builtins history-words
zstyle ':completion:*:complete:*:' tag-order '! ancestor-directories recent-directories recent-files' -
zstyle ':completion:list-expand:*' extra-verbose yes

source ~/tools/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Key bindings
typeset -g -A key
key[Home]=$terminfo[khome]
key[End]=$terminfo[kend]
key[Insert]=$terminfo[kich1]
key[Backspace]=$terminfo[kbs]
key[Delete]=$terminfo[kdch1]
key[Up]=$terminfo[kcuu1]
key[Down]=$terminfo[kcud1]
key[Left]=$terminfo[kcub1]
key[Right]=$terminfo[kcuf1]
key[PageUp]=$terminfo[kpp]
key[PageDown]=$terminfo[knp]

bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey -M menuselect '^[' .vi-cmd-mode
bindkey $key[Home] beginning-of-line
bindkey $key[End] end-of-line
bindkey $key[Insert] overwrite-mode
bindkey $key[Backspace] backward-delete-char
bindkey $key[Delete] delete-char
bindkey $key[Left] backward-char
bindkey $key[Right] forward-char
bindkey $key[Up] up-line-or-search
bindkey $key[Down] down-line-or-select

# alias autocomplete
compdef _gf gf
compdef _just jj

eval "$(zoxide init --cmd 'j' --hook 'pwd' zsh)"
eval "$(starship init zsh)"
