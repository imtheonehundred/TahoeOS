#!/bin/bash
set -euo pipefail

log_info() { echo "[17-branding] $1"; }

log_info "Applying TahoeOS branding..."

create_os_release() {
    log_info "Creating os-release..."
    
    cat > /etc/os-release << 'EOF'
NAME="TahoeOS"
VERSION="2026.1"
ID=tahoeos
ID_LIKE=fedora
VERSION_ID=2026.1
VERSION_CODENAME="Tahoe"
PRETTY_NAME="TahoeOS 2026.1 (Tahoe)"
ANSI_COLOR="0;38;2;0;122;255"
LOGO=tahoeos-logo
CPE_NAME="cpe:/o:tahoeos:tahoeos:2026.1"
HOME_URL="https://tahoeos.org"
DOCUMENTATION_URL="https://docs.tahoeos.org"
SUPPORT_URL="https://tahoeos.org/support"
BUG_REPORT_URL="https://github.com/tahoeos/tahoeos/issues"
PRIVACY_POLICY_URL="https://tahoeos.org/privacy"
EOF

    cat > /etc/lsb-release << 'EOF'
DISTRIB_ID=TahoeOS
DISTRIB_RELEASE=2026.1
DISTRIB_CODENAME=Tahoe
DISTRIB_DESCRIPTION="TahoeOS 2026.1 (Tahoe)"
EOF
}

setup_wallpapers() {
    log_info "Setting up wallpapers..."
    
    mkdir -p /usr/share/backgrounds/tahoeos
    mkdir -p /usr/share/gnome-background-properties
    
    cat > /usr/share/gnome-background-properties/tahoeos.xml << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
  <wallpaper deleted="false">
    <name>TahoeOS Default</name>
    <filename>/usr/share/backgrounds/tahoeos/default.jpg</filename>
    <filename-dark>/usr/share/backgrounds/tahoeos/default-dark.jpg</filename-dark>
    <options>zoom</options>
    <shade_type>solid</shade_type>
    <pcolor>#1a1a2e</pcolor>
    <scolor>#1a1a2e</scolor>
  </wallpaper>
</wallpapers>
EOF
}

setup_plymouth() {
    log_info "Configuring Plymouth theme..."
    
    mkdir -p /usr/share/plymouth/themes/tahoeos
    
    cat > /usr/share/plymouth/themes/tahoeos/tahoeos.plymouth << 'EOF'
[Plymouth Theme]
Name=TahoeOS
Description=TahoeOS boot splash
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/tahoeos
ScriptFile=/usr/share/plymouth/themes/tahoeos/tahoeos.script
EOF
}

setup_gdm() {
    log_info "Configuring GDM..."
    
    mkdir -p /etc/dconf/db/gdm.d
    cat > /etc/dconf/db/gdm.d/01-tahoeos << 'EOF'
[org/gnome/login-screen]
logo='/usr/share/pixmaps/tahoeos-logo.png'
banner-message-enable=false
disable-user-list=false

[org/gnome/desktop/interface]
gtk-theme='MacTahoe-Dark'
icon-theme='TahoeOS'
cursor-theme='MacTahoe-cursors'
EOF
}

create_os_release
setup_wallpapers
setup_plymouth
setup_gdm

log_info "Branding complete"
