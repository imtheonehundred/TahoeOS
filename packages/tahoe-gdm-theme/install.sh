#!/bin/bash
set -e

mkdir -p /etc/dconf/db/gdm.d/

cat > /etc/dconf/db/gdm.d/01-tahoeos-gdm << 'EOF'
[org/gnome/login-screen]
logo='/usr/share/tahoeos/logo.png'
banner-message-enable=false
disable-user-list=false

[org/gnome/desktop/interface]
gtk-theme='TahoeOS'
icon-theme='TahoeOS'
cursor-theme='TahoeOS-cursors'
font-name='Inter 11'

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/tahoeos/tahoe-dark.png'
picture-options='zoom'
EOF

dconf update

echo "tahoe-gdm-theme installed"
