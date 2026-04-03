#!/bin/bash
set -e

mkdir -p /etc/dconf/db/local.d
mkdir -p /etc/dconf/profile

cat > /etc/dconf/profile/user << 'EOF'
user-db:user
system-db:local
EOF

cat > /etc/dconf/db/local.d/00-tahoeos << 'EOF'
[org/gnome/desktop/interface]
gtk-theme='TahoeOS'
icon-theme='TahoeOS'
cursor-theme='TahoeOS-cursors'
font-name='Inter 11'
document-font-name='Inter 11'
monospace-font-name='JetBrains Mono 10'
color-scheme='prefer-dark'
enable-animations=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'
titlebar-font='Inter Bold 11'
theme='TahoeOS'

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/tahoeos/tahoe-dark.png'
picture-uri-dark='file:///usr/share/backgrounds/tahoeos/tahoe-dark.png'
picture-options='zoom'

[org/gnome/desktop/sound]
theme-name='TahoeOS'
event-sounds=true

[org/gnome/shell]
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'tahoe-notifications@tahoeos.org', 'tahoe-window-manager@tahoeos.org', 'tahoe-lock-screen@tahoeos.org']
EOF

dconf update

echo "tahoe-default-settings installed"
