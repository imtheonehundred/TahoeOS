#!/bin/bash
set -e

mkdir -p /usr/share/backgrounds/tahoeos

cat > /usr/share/backgrounds/tahoeos/tahoe-light.xml << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>TahoeOS Light</name>
    <filename>/usr/share/backgrounds/tahoeos/tahoe-light.png</filename>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#667eea</pcolor>
    <scolor>#667eea</scolor>
  </wallpaper>
</wallpapers>
EOF

cat > /usr/share/backgrounds/tahoeos/tahoe-dark.xml << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>TahoeOS Dark</name>
    <filename>/usr/share/backgrounds/tahoeos/tahoe-dark.png</filename>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#1a1a2e</pcolor>
    <scolor>#1a1a2e</scolor>
  </wallpaper>
</wallpapers>
EOF

convert -size 3840x2160 \
    -define gradient:direction=diagonal \
    gradient:'#667eea-#764ba2' \
    /usr/share/backgrounds/tahoeos/tahoe-light.png 2>/dev/null || \
    convert -size 3840x2160 xc:'#667eea' /usr/share/backgrounds/tahoeos/tahoe-light.png 2>/dev/null || \
    echo "ImageMagick not available, skipping wallpaper generation"

convert -size 3840x2160 \
    -define gradient:direction=diagonal \
    gradient:'#1a1a2e-#16213e' \
    /usr/share/backgrounds/tahoeos/tahoe-dark.png 2>/dev/null || \
    convert -size 3840x2160 xc:'#1a1a2e' /usr/share/backgrounds/tahoeos/tahoe-dark.png 2>/dev/null || true

mkdir -p /usr/share/gnome-background-properties
cp /usr/share/backgrounds/tahoeos/*.xml /usr/share/gnome-background-properties/

echo "tahoe-wallpapers installed"
