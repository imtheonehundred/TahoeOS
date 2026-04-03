#!/bin/bash
set -euo pipefail

log_info() { echo "[16-config] $1"; }

log_info "Applying system configuration..."

apply_dconf() {
    log_info "Compiling dconf database..."
    
    mkdir -p /etc/dconf/profile
    cat > /etc/dconf/profile/user << 'EOF'
user-db:user
system-db:local
EOF

    dconf update 2>/dev/null || true
}

setup_skel() {
    log_info "Setting up skeleton directory..."
    
    mkdir -p /etc/skel/.config
    mkdir -p /etc/skel/.local/share/applications
    mkdir -p /etc/skel/.local/share/tahoeos
    
    cat > /etc/skel/.config/user-dirs.dirs << 'EOF'
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_TEMPLATES_DIR="$HOME/Templates"
XDG_VIDEOS_DIR="$HOME/Videos"
EOF

    touch /etc/skel/.local/share/tahoeos/.first-run
}

configure_flatpak() {
    log_info "Configuring Flatpak..."
    
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
    
    mkdir -p /etc/profile.d
    cat > /etc/profile.d/flatpak.sh << 'EOF'
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
EOF
}

configure_mimeapps() {
    log_info "Setting default applications..."
    
    cat > /etc/skel/.config/mimeapps.list << 'EOF'
[Default Applications]
x-scheme-handler/http=firefox.desktop
x-scheme-handler/https=firefox.desktop
x-scheme-handler/mailto=org.gnome.Geary.desktop
text/html=firefox.desktop
application/pdf=org.gnome.Evince.desktop
image/jpeg=org.gnome.eog.desktop
image/png=org.gnome.eog.desktop
image/gif=org.gnome.eog.desktop
video/mp4=vlc.desktop
audio/mpeg=vlc.desktop
inode/directory=org.gnome.Nautilus.desktop
application/x-ms-dos-executable=tahoe-wine-handler.desktop
EOF
}

apply_dconf
setup_skel
configure_flatpak
configure_mimeapps

log_info "System configuration complete"
