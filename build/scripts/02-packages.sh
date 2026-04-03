#!/bin/bash
set -euo pipefail

log_info() { echo "[02-packages] $1"; }

log_info "Installing base packages..."

PACKAGES=(
    # Desktop environment
    "@workstation-product-environment"
    "gnome-shell"
    "gnome-session"
    "gnome-control-center"
    "gnome-tweaks"
    "gnome-extensions-app"
    "nautilus"
    "gnome-terminal"
    "gnome-calculator"
    "gnome-calendar"
    "gnome-weather"
    "gnome-clocks"
    "gnome-maps"
    "gnome-photos"
    "gnome-music"
    "evince"
    "eog"
    "gedit"
    "file-roller"
    "gnome-disk-utility"
    "gnome-system-monitor"
    "gnome-software"
    "gnome-shell-extension-dash-to-dock"
    "gnome-shell-extension-appindicator"
    
    # Multimedia
    "vlc"
    "ffmpeg"
    "gstreamer1-plugins-base"
    "gstreamer1-plugins-good"
    "gstreamer1-plugins-bad-free"
    "gstreamer1-plugins-ugly"
    "gstreamer1-libav"
    "pipewire"
    "pipewire-pulseaudio"
    "wireplumber"
    
    # Development
    "git"
    "gcc"
    "gcc-c++"
    "make"
    "cmake"
    "python3"
    "python3-pip"
    "python3-gobject"
    "gtk4-devel"
    "libadwaita-devel"
    
    # Gaming (core)
    "steam"
    "wine"
    "wine-mono"
    "wine-gecko"
    "winetricks"
    "lutris"
    "gamescope"
    "mangohud"
    "gamemode"
    "dxvk"
    "vkd3d"
    
    # Graphics/Vulkan
    "vulkan-loader"
    "vulkan-tools"
    "mesa-vulkan-drivers"
    "mesa-dri-drivers"
    
    # System utilities
    "flatpak"
    "dnf-plugins-core"
    "btrfs-progs"
    "snapper"
    "firewalld"
    "NetworkManager"
    "NetworkManager-wifi"
    "bluez"
    "cups"
    "fwupd"
    
    # Fonts
    "google-noto-fonts-common"
    "google-noto-sans-fonts"
    "google-noto-serif-fonts"
    "google-noto-emoji-fonts"
    "liberation-fonts"
    "dejavu-fonts"
    
    # Icon extraction (for Wine)
    "icoutils"
    "ImageMagick"
    "p7zip"
    
    # Theme build deps
    "sassc"
    "inkscape"
    "optipng"
)

log_info "Package list prepared (${#PACKAGES[@]} packages)"
echo "${PACKAGES[@]}" > /tmp/tahoeos-packages.txt

log_info "Packages ready for installation"
