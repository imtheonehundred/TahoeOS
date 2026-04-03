#!/bin/bash
set -e

mkdir -p /etc/dconf/db/local.d

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/terminal/legacy]
theme-variant='dark'
default-show-menubar=false

[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
visible-name='TahoeOS'
use-system-font=false
font='JetBrains Mono 11'
use-theme-colors=false
foreground-color='#f8f8f2'
background-color='#1e1e2e'
palette=['#45475a', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#bac2de', '#585b70', '#f38ba8', '#a6e3a1', '#f9e2af', '#89b4fa', '#f5c2e7', '#94e2d5', '#a6adc8']
use-transparent-background=true
background-transparency-percent=5
scrollback-unlimited=true
audible-bell=false
EOF

cat > /etc/skel/.zshrc << 'EOF'
export EDITOR=nano
export PATH="$HOME/.local/bin:$PATH"

PROMPT='%F{blue}%~%f %F{green}>%f '

alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'
alias open='xdg-open'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
EOF

dconf update

echo "tahoe-terminal installed"
