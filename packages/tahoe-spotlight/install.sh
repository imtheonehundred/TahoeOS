#!/bin/bash
set -e

dnf install -y ulauncher

mkdir -p /etc/skel/.config/ulauncher

cat > /etc/skel/.config/ulauncher/settings.json << 'EOF'
{
    "blacklisted-desktop-dirs": "/usr/share/locale",
    "clear-previous-query": true,
    "hotkey-show-app": "<Super>space",
    "render-on-screen": "mouse-pointer-monitor",
    "show-indicator-icon": false,
    "show-recent-apps": "3",
    "terminal-command": "gnome-terminal",
    "theme-name": "dark"
}
EOF

mkdir -p /etc/skel/.config/autostart
cat > /etc/skel/.config/autostart/ulauncher.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Ulauncher
Exec=ulauncher --hide-window
Hidden=false
EOF

echo "tahoe-spotlight installed"
