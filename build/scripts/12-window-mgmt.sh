#!/bin/bash
set -euo pipefail

log_info() { echo "[12-window-mgmt] $1"; }

log_info "Configuring window management..."

install_extensions() {
    log_info "Installing GNOME extensions..."
    
    EXTENSIONS=(
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
    )
    
    EXTENSIONS_DIR="/usr/share/gnome-shell/extensions"
    mkdir -p "$EXTENSIONS_DIR"
    
    for ext in "${EXTENSIONS[@]}"; do
        log_info "Extension queued: $ext"
    done
}

configure_dock() {
    log_info "Configuring Dash-to-Dock..."
    
    mkdir -p /etc/dconf/db/local.d
    cat > /etc/dconf/db/local.d/02-dock << 'EOF'
[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
dock-fixed=true
extend-height=false
height-fraction=0.9
dash-max-icon-size=48
background-opacity=0.8
transparency-mode='FIXED'
custom-theme-shrink=true
show-apps-at-top=true
show-trash=false
show-mounts=false
click-action='minimize-or-previews'
scroll-action='cycle-windows'
animate-show-apps=true
EOF
}

configure_window_behavior() {
    log_info "Configuring window behavior..."
    
    cat > /etc/dconf/db/local.d/03-window << 'EOF'
[org/gnome/mutter]
center-new-windows=true
edge-tiling=true
dynamic-workspaces=true

[org/gnome/desktop/wm/preferences]
button-layout='close,minimize,maximize:'
focus-mode='click'
auto-raise=false
resize-with-right-button=true

[org/gnome/shell/window-switcher]
current-workspace-only=false

[org/gnome/desktop/wm/keybindings]
close=['<Super>q']
minimize=['<Super>m']
maximize=['<Super>Up']
show-desktop=['<Super>d']
switch-applications=['<Super>Tab']
switch-windows=['<Alt>Tab']
EOF
}

install_extensions
configure_dock
configure_window_behavior

log_info "Window management configuration complete"
