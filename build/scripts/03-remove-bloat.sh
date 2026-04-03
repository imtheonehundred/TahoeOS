#!/bin/bash
set -euo pipefail

log_info() { echo "[03-remove-bloat] $1"; }

log_info "Removing bloatware..."

REMOVE_PACKAGES=(
    "libreoffice*"
    "rhythmbox"
    "totem"
    "cheese"
    "gnome-contacts"
    "gnome-tour"
    "gnome-user-docs"
    "yelp"
    "simple-scan"
    "gnome-boxes"
    "gnome-connections"
    "mediawriter"
    "fedora-bookmarks"
    "fedora-chromium-config"
    "fedora-workstation-backgrounds"
)

log_info "Bloat packages to remove:"
for pkg in "${REMOVE_PACKAGES[@]}"; do
    echo "  - $pkg"
done

echo "${REMOVE_PACKAGES[@]}" > /tmp/tahoeos-remove.txt

log_info "Bloat removal list ready"
