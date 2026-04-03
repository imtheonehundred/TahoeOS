#!/bin/bash
set -euo pipefail

log_info() { echo "[05-themes] $1"; }

THEME_DIR="/usr/share/themes/TahoeOS"
BUILD_TEMP="/tmp/tahoeos-themes"

log_info "Setting up theme build..."

mkdir -p "$BUILD_TEMP"
cd "$BUILD_TEMP"

log_info "Cloning MacTahoe GTK theme..."
if [[ ! -d "MacTahoe-gtk-theme" ]]; then
    git clone --depth=1 https://github.com/vinceliuice/MacTahoe-gtk-theme.git
fi

log_info "Cloning GNOME macOS Tahoe shell theme..."
if [[ ! -d "GNOME-macOS-Tahoe" ]]; then
    git clone --depth=1 https://github.com/kayozxo/GNOME-macOS-Tahoe.git
fi

log_info "Installing GTK theme..."
cd MacTahoe-gtk-theme
./install.sh -d "$THEME_DIR" -c dark -t default

log_info "Installing shell theme..."
cd ../GNOME-macOS-Tahoe
mkdir -p /usr/share/gnome-shell/themes/TahoeOS
cp -r gnome-shell/* /usr/share/gnome-shell/themes/TahoeOS/ 2>/dev/null || true

log_info "Theme installation complete"
