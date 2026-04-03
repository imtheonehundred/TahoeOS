#!/bin/bash
set -euo pipefail

# TahoeOS VPS Setup Script
# Run this ONCE on a fresh Fedora 42 VPS

echo "=== TahoeOS Build Environment Setup ==="

if [[ $EUID -ne 0 ]]; then
   echo "Run as root: sudo bash setup-vps.sh"
   exit 1
fi

echo "[1/4] Updating system..."
dnf upgrade -y --refresh

echo "[2/4] Installing build tools..."
dnf install -y \
    lorax \
    livecd-tools \
    pykickstart \
    anaconda \
    git \
    curl \
    wget

echo "[3/4] Installing theme build tools..."
dnf install -y \
    sassc \
    gtk-murrine-engine \
    inkscape \
    optipng

echo "[4/4] Setting up build directories..."
mkdir -p /var/lib/tahoeos-build
mkdir -p /home/tahoeos

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Clone the repo:"
echo "     git clone https://github.com/YOUR_USER/tahoeos.git /home/tahoeos"
echo ""
echo "  2. Build the ISO:"
echo "     cd /home/tahoeos && sudo ./build/build.sh"
echo ""
echo "Expected build time: 30-60 minutes"
echo "Expected ISO size: ~3-4 GB"
