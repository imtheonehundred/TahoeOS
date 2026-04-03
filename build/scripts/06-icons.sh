#!/bin/bash
set -euo pipefail

log_info() { echo "[06-icons] $1"; }

ICON_DIR="/usr/share/icons/TahoeOS"
BUILD_TEMP="/tmp/tahoeos-icons"

log_info "Setting up icon theme..."

mkdir -p "$BUILD_TEMP"
cd "$BUILD_TEMP"

log_info "Cloning MacTahoe icon theme..."
if [[ ! -d "MacTahoe-icon-theme" ]]; then
    git clone --depth=1 https://github.com/vinceliuice/MacTahoe-icon-theme.git
fi

log_info "Installing icon theme..."
cd MacTahoe-icon-theme
./install.sh -d /usr/share/icons -n TahoeOS

log_info "Updating icon cache..."
gtk-update-icon-cache -f "$ICON_DIR" 2>/dev/null || true

log_info "Icon theme installation complete"
