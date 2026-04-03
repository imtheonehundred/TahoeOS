#!/bin/bash
set -e

dnf install -y snapper btrfs-progs

mkdir -p /usr/share/tahoe-backup
cp src/tahoe-backup.py /usr/share/tahoe-backup/

cat > /usr/bin/tahoe-backup << 'EOF'
#!/bin/bash
exec python3 /usr/share/tahoe-backup/tahoe-backup.py "$@"
EOF
chmod +x /usr/bin/tahoe-backup

cat > /usr/share/applications/org.tahoeos.backup.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Time Machine
Comment=Backup and restore with Btrfs snapshots
Exec=tahoe-backup
Icon=drive-harddisk
Categories=System;
EOF

snapper -c root create-config / 2>/dev/null || true

echo "tahoe-backup installed"
