#!/bin/sh
# shellcheck disable=SC2139,SC3009,SC3010

### utils ###

color_reset="\x1b[0m"
color_red="\x1b[31m"

err() {
  echo "${color_red}[!]${color_reset} $1" >&2
}

### Aliases ###

# Package managers
alias p='pacman'
alias sp='sudo pacman'

# Edit
alias e="$EDITOR"
alias se="sudoedit"
alias ee="$EDITOR ~/.config/nvim/init.vim"
alias eek="$EDITOR ~/.config/nvim/lua/settings/keymaps.lua"
alias eep="$EDITOR ~/.config/nvim/lua/plugins/plugins.lua"
alias eel="$EDITOR ~/.config/nvim/lua/plugins/lsp.lua"
alias ep="cd -P ~/.config/nvim/lua/plugins/ && ${EDITOR} -c 'Telescope find_files'"
alias eet="$EDITOR ~/.config/tmux/tmux.conf"
alias es="$EDITOR ~/git/dotfiles/shells/shared.sh"
alias eb="$EDITOR ~/.bashrc"
alias ez="$EDITOR ~/.zshrc"
alias ea="xargs -d '\n' $EDITOR"
alias er="$EDITOR README.md"
alias et="$EDITOR TODO.md"
alias ek="$EDITOR ~/.config/sxhkd/sxhkdrc"
alias en='vidir'
alias eo="$EDITOR -c 'Telescope oldfiles'"

# git
alias g='git'
alias gr='cd_git_root'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gD='git difftool'
alias gD='git difftool HEAD'
alias gs='git status'
alias ga='git add .'
alias gc='git commit'
alias gp='git push'
alias gP='git pull'
alias gC='git rev-parse --short HEAD'
alias gCC='git rev-parse HEAD'
alias gcl='git clone --depth 1'
alias {G,lg}='lazygit'

# ls
if type exa > /dev/null; then
  alias {ls,l,sl,exa}='exa --group-directories-first'
  alias la='exa -a'
  alias ll='exa -Fgl --header'
  alias lla='exa -aFgl --header'
  alias lld='exa -dgl --header'
  alias tree='exa -F --git-ignore --tree'
  alias ltree='exa -Fl --tree'
else
  alias {ls,l,sl}='ls -hN --color=auto --group-directories-first'
  alias la='ls -A'
  alias ll='ls -l'
  alias lla='ls -Al'
  alias lld='ls -dl'
fi

# grep
alias grep='grep --color=auto'
alias egrep='grep -E'
alias fgrep='grep -F'

# tmux
alias t='tmux'
alias tt='tmux new -A -s general'

# Other conveniences
alias cp='cp -i'
alias df='df -h'
alias free='free -m'
alias ..='cd ..'
alias ...='cd ../..'
alias i='setsid sxiv -ab'
alias z='setsid zathura'
alias f="$FILE_CLI"
alias c='xclip -selection clipboard -r'
alias cv='xclip -o'
alias q='exit'
alias o='xdg-open'
alias h='help'
alias hh='tldr'
alias py='python3'
alias pyc='python3 -c'
alias bwp='bw generate -ulns --length'
alias m='setsid mpv'
alias mpvrand="xargs -d '\n' mpv --shuffle"
alias ard='arduino-cli'
alias rcsync='rclone sync -P'
alias b="bat"
alias batdiff="batdiff --delta"
alias dr='dragon -a -x'
alias vpn="sudo openvpn"
alias frm='fuzzy-rm'
alias jj='just'
alias jl='just --list'
alias cls='clear'

# pueue
alias pq='pueue'
alias pf='pueue-fuzzy'
alias psum='pueue status -j | jq -r -f ~/git/scripts/jq/pueue_summary.jq'
alias pqc='pueue clean -s'
alias pqa='pueue add'
alias pqr='pueue restart -ai'

# pentest
alias r2='r2 -A'
alias trid="LC_ALL=C trid"
alias pyh='python3 -m http.server'
alias pyH='python-http-server'
alias msf="msfconsole -q"
alias 600='chmod 600'
alias pwncat="python -m pwncat -c $HOME/.config/pwncat/pwncatrc"
alias ncl='nc -lnvp'

# Internet
alias yt='yt-dlp --no-playlist'
alias yta='yt-dlp --no-playlist --extract-audio --audio-format mp3'    # Download audio
alias ytp='yt-dlp -o "%(playlist_index)s. %(title)s [%(id)s].%(ext)s"' # Download video playlist
alias get-ip='curl ifconfig.me'
alias trc='transmission-remote -N'
alias bm='buku'
alias fbm='fuzzy-bookmark'

# Encoding & Decoding
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias b64='base64'
alias b32='base32'

### Functions ###

x() {
  if [ $# -ne 1 ]; then
    # archive extractor
    err "usage: x <file>"
    return 1
  fi
  if [ -f "$1" ]; then
    case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.xz) unxz "$1" ;;
    *) err "'$1' cannot be extracted via x()" && return 1 ;;
    esac
  else
    err "'$1' is not a valid file"
    return 1
  fi
}

mkcd() {
  mkdir "$1"
  cd "$1" || exit 1
}

cd_git_root() {
  root="$(git rev-parse --show-toplevel)" && cd "$root" || exit 1
}

fj() {
  # fuzzy find jump to a dir or the dir containing a file
  target="$(fd --hidden --follow --exclude .git | fzf --disabled)" &&
    if [ -d "$target" ]; then
      cd "$target"
    else
      cd "${target%/*}"
    fi || exit 1
}

ed() {
  # edit dotfiles
  fd -H -tf -tl . ~/git/dotfiles/ | fzf -m | ea
}

fp() {
  # fuzzy-find file path and copy it to clipboard
  fzf | c
}

icmpdump() {
  if [ $# -eq 0 ]; then
    sudo tcpdump -i wlp3s0 icmp
  else
    sudo tcpdump -i "$1" icmp
  fi
}

fuzzhost() {
  ffuf -u "http://${1}/" -H "Host: FUZZ.${1}" -w ~/tools/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
}

rs() {
  rustscan -a "$1" -- -sCV -oA init
}

rm_dead_links() {
  find . -xtype l -exec rm {} \;
}

# print space-separated arguments 1 per line
pl() {
  for i in "$@"; do
    echo "$i"
  done
}

# file type of executable
fx() {
  for arg in "$@"; do
    target="$(which "$arg")"
    if [[ ! -x "$target" ]]; then
      err "'$arg' is not an executable: $target"
      continue
    fi
    file "$target"
  done
}

# browse package info
pi() {
  pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'
}

pacman_eat_orphans() {
  sudo pacman -Rs "$(pacman -Qqtd)"
}

# Embed subtitles file to video
# Args:
#   $1: input/output video file
#   $2: input subtitles video
#   ${@[@]:3}: the rest is passed as arguments to ffmpeg
sub_vid() {
  if [ $# -lt 2 ]; then
    echo "Usage: sub_vid VIDEO SUBTITLES [ffmpeg_args...]" 1>&2
    return 1
  fi

  tmp="$(mktemp --suffix=".${1##*.}")"
  ffmpeg -i "$1" -i "$2" -c:v copy -c:a copy -c:s mov_text -y "$tmp" "${@[@]:3}" && mv "$tmp" "${1}"
}
