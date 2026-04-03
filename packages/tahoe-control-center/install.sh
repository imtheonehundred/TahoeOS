#!/bin/bash
set -e

mkdir -p /usr/share/tahoe-control-center
cp src/main.py /usr/share/tahoe-control-center/

cat > /usr/bin/tahoe-control-center << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-control-center/main.py "$@"
EOF
chmod +x /usr/bin/tahoe-control-center

cat > /usr/share/applications/org.tahoeos.controlcenter.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=System Settings
Comment=TahoeOS System Settings
Exec=tahoe-control-center
Icon=preferences-system
Categories=Settings;System;
EOF

echo "tahoe-control-center installed"
