#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/packages"

echo "=== TahoeOS Package Installer ==="
echo "Installing all 30 packages..."
echo

PACKAGES=(
    "tahoe-fonts"
    "tahoe-gtk-theme"
    "tahoe-shell-theme"
    "tahoe-icon-theme"
    "tahoe-cursor-theme"
    "tahoe-wallpapers"
    "tahoe-grub-theme"
    "tahoe-plymouth-theme"
    "tahoe-gdm-theme"
    "tahoe-sound-theme"
    "tahoe-default-settings"
    "tahoe-branding"
    "tahoe-control-center"
    "tahoe-app-store"
    "tahoe-gpu-manager"
    "tahoe-wine-integration"
    "tahoe-gaming"
    "tahoe-update-manager"
    "tahoe-notifications"
    "tahoe-spotlight"
    "tahoe-dock"
    "tahoe-terminal"
    "tahoe-backup"
    "tahoe-security"
    "tahoe-window-manager"
    "tahoe-lock-screen"
    "tahoe-kernel-config"
    "tahoe-browser"
    "tahoe-app-mapping"
    "tahoe-shell-config"
    "tahoe-accessibility"
    "tahoe-help"
    "tahoe-installer"
)

INSTALLED=0
FAILED=0

for pkg in "${PACKAGES[@]}"; do
    echo "[$((INSTALLED + FAILED + 1))/${#PACKAGES[@]}] Installing $pkg..."
    
    if [[ -f "$PACKAGES_DIR/$pkg/install.sh" ]]; then
        cd "$PACKAGES_DIR/$pkg"
        if bash install.sh; then
            ((INSTALLED++))
            echo "  OK"
        else
            ((FAILED++))
            echo "  FAILED"
        fi
    else
        echo "  SKIPPED (no install.sh)"
        ((FAILED++))
    fi
done

echo
echo "=== Installation Complete ==="
echo "Installed: $INSTALLED"
echo "Failed: $FAILED"

dconf update 2>/dev/null || true
fc-cache -f 2>/dev/null || true
update-desktop-database /usr/share/applications 2>/dev/null || true

echo
echo "Run 'dracut -f --regenerate-all' to update initramfs"
echo "Reboot to apply all changes"
