#!/bin/bash
set -e

cd /tmp
rm -rf WhiteSur-icon-theme

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme

./install.sh -a -b

mkdir -p /usr/share/icons
cp -r "$HOME/.local/share/icons/WhiteSur" /usr/share/icons/TahoeOS 2>/dev/null || \
cp -r /root/.local/share/icons/WhiteSur /usr/share/icons/TahoeOS 2>/dev/null || true

cd /tmp
rm -rf WhiteSur-icon-theme

echo "tahoe-icon-theme installed"
