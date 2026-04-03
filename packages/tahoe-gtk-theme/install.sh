#!/bin/bash
set -e

cd /tmp
rm -rf WhiteSur-gtk-theme

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git
cd WhiteSur-gtk-theme

./install.sh -c Dark -l -N glassy --tweaks macOS

mkdir -p /usr/share/themes
cp -r "$HOME/.themes/WhiteSur-Dark" /usr/share/themes/TahoeOS 2>/dev/null || \
cp -r /root/.themes/WhiteSur-Dark /usr/share/themes/TahoeOS 2>/dev/null || true

cd /tmp
rm -rf WhiteSur-gtk-theme

echo "tahoe-gtk-theme installed"
