#!/bin/bash
set -e

dnf install -y zsh

sed -i 's|SHELL=/bin/bash|SHELL=/bin/zsh|' /etc/default/useradd 2>/dev/null || true

mkdir -p /etc/dconf/db/local.d

cat >> /etc/dconf/db/local.d/00-tahoeos << 'EOF'

[org/gnome/shell]
disable-extension-version-validation=true

[org/gnome/desktop/interface]
clock-show-date=true
clock-show-seconds=false
clock-show-weekday=true
clock-format='12h'

[org/gnome/shell/weather]
automatic-location=true

[org/gnome/desktop/calendar]
show-weekdate=false
EOF

dconf update

echo "tahoe-shell-config installed"
