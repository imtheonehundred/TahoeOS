#!/bin/bash
set -e

mkdir -p /etc/dconf/db/local.d

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/shell]
favorite-apps=['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Settings.desktop', 'steam.desktop']

[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
dash-max-icon-size=48
show-trash=false
show-mounts=false
transparency-mode='FIXED'
background-opacity=0.8
running-indicator-style='DOTS'
click-action='minimize-or-previews'
scroll-action='cycle-windows'
custom-theme-shrink=true
disable-overview-on-startup=true
autohide=true
intellihide=true
intellihide-mode='FOCUS_APPLICATION_WINDOWS'
animation-time=0.2
show-apps-at-top=false
hot-keys=true
EOF

dconf update

echo "tahoe-dock installed"
