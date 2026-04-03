#!/bin/bash
set -e

cd /tmp
rm -rf WhiteSur-gtk-theme

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme

./install.sh -c Dark -N glassy
./tweaks.sh -g -F

mkdir -p /usr/share/gnome-shell/theme
cp -r "$HOME/.themes/WhiteSur-Dark/gnome-shell" /usr/share/gnome-shell/theme/TahoeOS 2>/dev/null || \
cp -r /root/.themes/WhiteSur-Dark/gnome-shell /usr/share/gnome-shell/theme/TahoeOS 2>/dev/null || true

cd /tmp
rm -rf WhiteSur-gtk-theme

echo "tahoe-shell-theme installed"
