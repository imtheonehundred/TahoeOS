#!/bin/bash
set -euo pipefail

log_info() { echo "[13-shell] $1"; }

log_info "Configuring GNOME Shell..."

configure_shell_theme() {
    log_info "Setting shell theme..."
    
    mkdir -p /etc/dconf/db/local.d
    cat > /etc/dconf/db/local.d/04-shell << 'EOF'
[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'org.tahoeos.appstore.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop']
disable-user-extensions=false
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'appindicatorsupport@rgcjonas.gmail.com']

[org/gnome/desktop/interface]
gtk-theme='MacTahoe-Dark'
icon-theme='TahoeOS'
cursor-theme='MacTahoe-cursors'
font-name='SF Pro Display 11'
document-font-name='SF Pro Display 11'
monospace-font-name='SF Mono 10'
color-scheme='prefer-dark'
enable-animations=true
clock-show-weekday=true

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/tahoeos/default.jpg'
picture-uri-dark='file:///usr/share/backgrounds/tahoeos/default-dark.jpg'
picture-options='zoom'
primary-color='#1a1a2e'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/tahoeos/lock.jpg'
primary-color='#1a1a2e'
EOF
}

configure_sounds() {
    log_info "Configuring sound theme..."
    
    cat >> /etc/dconf/db/local.d/04-shell << 'EOF'

[org/gnome/desktop/sound]
theme-name='TahoeOS'
event-sounds=true
input-feedback-sounds=false
EOF
}

configure_terminal() {
    log_info "Configuring terminal..."
    
    cat > /etc/dconf/db/local.d/05-terminal << 'EOF'
[org/gnome/terminal/legacy]
theme-variant='dark'

[org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9]
visible-name='TahoeOS'
use-theme-colors=false
foreground-color='#f8f8f2'
background-color='#1a1a2e'
bold-color='#f8f8f2'
cursor-colors-set=true
cursor-foreground-color='#1a1a2e'
cursor-background-color='#f8f8f2'
use-transparent-background=true
background-transparency-percent=10
scrollback-unlimited=true
audible-bell=false
EOF
}

configure_shell_theme
configure_sounds
configure_terminal

dconf update 2>/dev/null || true

log_info "Shell configuration complete"
