#!/bin/bash
set -e

mkdir -p /usr/share/tahoe-update-manager
cp src/tahoe-update-manager.py /usr/share/tahoe-update-manager/

cat > /usr/bin/tahoe-update-manager << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-update-manager/tahoe-update-manager.py "$@"
EOF
chmod +x /usr/bin/tahoe-update-manager

cat > /usr/share/applications/org.tahoeos.updatemanager.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Software Update
Comment=Update TahoeOS
Exec=tahoe-update-manager
Icon=software-update-available
Categories=System;
EOF

echo "tahoe-update-manager installed"
