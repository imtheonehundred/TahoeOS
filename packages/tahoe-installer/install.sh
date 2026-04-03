#!/bin/bash
set -e

dnf install -y qt6-qtbase qt6-qtdeclarative qt6-qtquickcontrols2

mkdir -p /usr/share/tahoe-installer
cp src/*.qml /usr/share/tahoe-installer/

cat > /usr/bin/tahoe-installer << 'EOF'
#!/bin/bash
exec qml6 /usr/share/tahoe-installer/Main.qml "$@"
EOF
chmod +x /usr/bin/tahoe-installer

cat > /usr/share/applications/org.tahoeos.installer.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=TahoeOS Setup
Comment=Initial system setup
Exec=tahoe-installer
Icon=system-software-install
Categories=System;
NoDisplay=true
EOF

echo "tahoe-installer installed"
