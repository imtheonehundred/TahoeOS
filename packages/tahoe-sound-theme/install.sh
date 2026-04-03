#!/bin/bash
set -e

mkdir -p /usr/share/sounds/TahoeOS/stereo

cat > /usr/share/sounds/TahoeOS/index.theme << 'EOF'
[Sound Theme]
Name=TahoeOS
Comment=TahoeOS Sound Theme
Inherits=freedesktop
Directories=stereo

[stereo]
OutputProfile=stereo
EOF

for sound in bell button-pressed complete device-added device-removed dialog-error dialog-information dialog-warning; do
    ln -sf /usr/share/sounds/freedesktop/stereo/${sound}.oga /usr/share/sounds/TahoeOS/stereo/${sound}.oga 2>/dev/null || true
done

echo "tahoe-sound-theme installed"
