#!/bin/bash
set -e

dnf install -y webkit2gtk4.1

mkdir -p /usr/share/tahoe-help
cp src/tahoe-help.py /usr/share/tahoe-help/

cat > /usr/bin/tahoe-help << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-help/tahoe-help.py "$@"
EOF
chmod +x /usr/bin/tahoe-help

cat > /usr/share/applications/org.tahoeos.help.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=TahoeOS Help
Comment=Get help with TahoeOS
Exec=tahoe-help
Icon=help-browser
Categories=Documentation;
EOF

echo "tahoe-help installed"
