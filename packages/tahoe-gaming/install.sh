#!/bin/bash
set -e

dnf install -y \
    steam \
    lutris \
    wine \
    winetricks \
    gamescope \
    mangohud \
    gamemode \
    goverlay

dnf install -y \
    vulkan-loader \
    vulkan-tools \
    mesa-vulkan-drivers

if dnf list installed akmod-nvidia &>/dev/null; then
    dnf install -y nvidia-vaapi-driver
fi

systemctl --user enable --now gamemoded 2>/dev/null || true

cat > /etc/sysctl.d/99-gaming.conf << 'EOF'
vm.max_map_count=2147483642
EOF
sysctl -p /etc/sysctl.d/99-gaming.conf

echo "tahoe-gaming installed"
