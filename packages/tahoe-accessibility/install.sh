#!/bin/bash
set -e

mkdir -p /etc/dconf/db/local.d

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/desktop/a11y]
always-show-universal-access-status=false

[org/gnome/desktop/a11y/applications]
screen-magnifier-enabled=false
screen-reader-enabled=false

[org/gnome/desktop/a11y/interface]
high-contrast=false

[org/gnome/desktop/a11y/magnifier]
mag-factor=2.0
mouse-tracking='proportional'
screen-position='full-screen'

[org/gnome/desktop/interface]
text-scaling-factor=1.0
cursor-size=24
EOF

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/desktop/wm/keybindings]
toggle-fullscreen=['<Super>f']
maximize=['<Super>Up']
unmaximize=['<Super>Down']
EOF

dconf update

echo "tahoe-accessibility installed"
