#!/bin/bash
set -e

cd /tmp
rm -rf plymouth-theme-apple

git clone --depth=1 https://github.com/AdisonCavani/plymouth-theme-apple.git
cd plymouth-theme-apple

mkdir -p /usr/share/plymouth/themes/apple
cp -r apple/* /usr/share/plymouth/themes/apple/

plymouth-set-default-theme apple

dracut -f --regenerate-all 2>/dev/null || true

cd /tmp
rm -rf plymouth-theme-apple

echo "tahoe-plymouth-theme installed"
