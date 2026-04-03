#!/bin/bash
set -euo pipefail

log_info() { echo "[09-wine] $1"; }

log_info "Configuring Wine..."

setup_wine_defaults() {
    log_info "Setting up Wine defaults..."
    
    mkdir -p /etc/tahoeos/wine
    cat > /etc/tahoeos/wine/defaults.conf << 'EOF'
# TahoeOS Wine Configuration
WINEARCH=win64
WINE_LARGE_ADDRESS_AWARE=1
DXVK_HUD=fps
DXVK_LOG_LEVEL=none
VKD3D_LOG_LEVEL=none
STAGING_SHARED_MEMORY=1
WINE_FULLSCREEN_FSR=1
EOF
}

setup_wine_associations() {
    log_info "Setting up file associations..."
    
    mkdir -p /usr/share/mime/packages
    
    cat > /usr/share/mime/packages/wine-exe.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-ms-dos-executable">
    <comment>Windows Executable</comment>
    <comment xml:lang="en">Windows Executable</comment>
    <glob pattern="*.exe"/>
    <glob pattern="*.EXE"/>
  </mime-type>
  <mime-type type="application/x-msi">
    <comment>Windows Installer Package</comment>
    <glob pattern="*.msi"/>
    <glob pattern="*.MSI"/>
  </mime-type>
</mime-info>
EOF
}

setup_wine_fonts() {
    log_info "Setting up Wine font links..."
    
    cat > /etc/tahoeos/wine/fontconfig.sh << 'EOF'
#!/bin/bash
# Link system fonts to Wine prefix
WINEPREFIX="${1:-$HOME/.wine}"
FONTS_DIR="$WINEPREFIX/drive_c/windows/Fonts"

mkdir -p "$FONTS_DIR"

for font in /usr/share/fonts/liberation/*.ttf; do
    ln -sf "$font" "$FONTS_DIR/" 2>/dev/null
done

for font in /usr/share/fonts/google-noto/*.ttf; do
    ln -sf "$font" "$FONTS_DIR/" 2>/dev/null
done
EOF
    chmod +x /etc/tahoeos/wine/fontconfig.sh
}

create_wine_profile() {
    log_info "Creating Wine profile script..."
    
    cat > /etc/profile.d/tahoeos-wine.sh << 'EOF'
# TahoeOS Wine Environment
if [[ -f /etc/tahoeos/wine/defaults.conf ]]; then
    source /etc/tahoeos/wine/defaults.conf
fi
EOF
}

setup_wine_defaults
setup_wine_associations
setup_wine_fonts
create_wine_profile

log_info "Wine configuration complete"
