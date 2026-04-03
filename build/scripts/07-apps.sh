#!/bin/bash
set -euo pipefail

log_info() { echo "[07-apps] $1"; }

log_info "Installing TahoeOS custom apps..."

APPS_DIR="/usr/share"
BIN_DIR="/usr/bin"

install_app_store() {
    log_info "Installing tahoe-app-store..."
    
    mkdir -p "$APPS_DIR/tahoe-app-store"
    cp -r packages/tahoe-app-store/src/* "$APPS_DIR/tahoe-app-store/"
    
    cat > "$BIN_DIR/tahoe-app-store" << 'EOF'
#!/bin/bash
cd /usr/share/tahoe-app-store
exec python3 main.py "$@"
EOF
    chmod +x "$BIN_DIR/tahoe-app-store"
    
    cat > /usr/share/applications/org.tahoeos.appstore.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=App Store
GenericName=Application Manager
Comment=Browse and install applications
Exec=tahoe-app-store
Icon=org.gnome.Software
Categories=System;PackageManager;
Keywords=app;store;install;package;flatpak;wine;
StartupNotify=true
EOF
}

install_wine_handler() {
    log_info "Installing tahoe-wine-integration..."
    
    mkdir -p "$APPS_DIR/tahoe-wine-integration"
    cp -r packages/tahoe-wine-integration/src/* "$APPS_DIR/tahoe-wine-integration/"
    
    cat > "$BIN_DIR/tahoe-wine-handler" << 'EOF'
#!/bin/bash
cd /usr/share/tahoe-wine-integration
exec python3 tahoe-wine-handler.py "$@"
EOF
    chmod +x "$BIN_DIR/tahoe-wine-handler"
    
    cat > /usr/share/applications/tahoe-wine-handler.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Windows Application Installer
GenericName=Wine Handler
Comment=Install Windows applications
Exec=tahoe-wine-handler %f
Icon=application-x-ms-dos-executable
MimeType=application/x-ms-dos-executable;application/x-msdos-program;
Categories=System;Wine;
NoDisplay=true
Terminal=false
EOF

    mkdir -p /usr/share/mime/packages
    cat > /usr/share/mime/packages/tahoe-wine.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-ms-dos-executable">
    <comment>Windows Executable</comment>
    <glob pattern="*.exe"/>
  </mime-type>
</mime-info>
EOF
}

install_app_store
install_wine_handler

log_info "Custom apps installed"
