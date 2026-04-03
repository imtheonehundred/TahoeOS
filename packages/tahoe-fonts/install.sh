#!/bin/bash
set -e

mkdir -p /usr/share/fonts/tahoeos

cd /tmp

wget -q https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip
unzip -q -o Inter-4.0.zip -d inter
cp inter/Inter-*.ttf /usr/share/fonts/tahoeos/ 2>/dev/null || \
cp inter/Inter\ Desktop/*.ttf /usr/share/fonts/tahoeos/ 2>/dev/null || true
rm -rf inter Inter-4.0.zip

wget -q https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip
unzip -q -o JetBrainsMono-2.304.zip -d jbmono
cp jbmono/fonts/ttf/*.ttf /usr/share/fonts/tahoeos/
rm -rf jbmono JetBrainsMono-2.304.zip

fc-cache -f

echo "tahoe-fonts installed"
