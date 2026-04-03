#!/bin/bash
set -e

cd /tmp
rm -rf grub2-themes

git clone --depth=1 https://github.com/vinceliuice/grub2-themes.git
cd grub2-themes

./install.sh -t whitesur -s 2k

cd /tmp
rm -rf grub2-themes

echo "tahoe-grub-theme installed"
