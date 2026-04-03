#!/bin/bash
set -e

mkdir -p /usr/share/tahoeos
mkdir -p /etc/tahoeos

cat > /etc/tahoeos/branding.conf << 'EOF'
NAME="TahoeOS"
VERSION="2026.1"
CODENAME="Tahoe"
WEBSITE="https://tahoeos.org"
SUPPORT="https://github.com/tahoeos/tahoeos/issues"
EOF

cat > /etc/os-release << 'EOF'
NAME="TahoeOS"
VERSION="2026.1 (Tahoe)"
ID=tahoeos
ID_LIKE=fedora
VERSION_ID=2026.1
VERSION_CODENAME=tahoe
PRETTY_NAME="TahoeOS 2026.1 (Tahoe)"
ANSI_COLOR="0;38;2;102;126;234"
LOGO=tahoeos-logo
HOME_URL="https://tahoeos.org"
DOCUMENTATION_URL="https://tahoeos.org/docs"
SUPPORT_URL="https://github.com/tahoeos/tahoeos/issues"
BUG_REPORT_URL="https://github.com/tahoeos/tahoeos/issues"
VARIANT_ID=workstation
EOF

ln -sf /etc/os-release /usr/lib/os-release

cat > /etc/issue << 'EOF'
TahoeOS 2026.1 (Tahoe)
Kernel \r on an \m (\l)

EOF

cat > /etc/issue.net << 'EOF'
TahoeOS 2026.1 (Tahoe)
EOF

echo "tahoe-branding installed"
