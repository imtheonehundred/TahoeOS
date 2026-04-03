#!/bin/bash
set -e

cd /tmp
rm -rf WhiteSur-cursors

git clone --depth=1 https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors

./install.sh

mkdir -p /usr/share/icons
cp -r "$HOME/.local/share/icons/WhiteSur-cursors" /usr/share/icons/TahoeOS-cursors 2>/dev/null || \
cp -r /root/.local/share/icons/WhiteSur-cursors /usr/share/icons/TahoeOS-cursors 2>/dev/null || true

cd /tmp
rm -rf WhiteSur-cursors

echo "tahoe-cursor-theme installed"
