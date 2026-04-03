#!/bin/bash
set -euo pipefail

log_info() { echo "[14-vfs] $1"; }

log_info "Configuring virtual filesystem..."

configure_gvfs() {
    log_info "Configuring GVFS..."
    
    mkdir -p /etc/dconf/db/local.d
    cat > /etc/dconf/db/local.d/06-vfs << 'EOF'
[org/gnome/desktop/media-handling]
automount=true
automount-open=true
autorun-never=true

[org/gtk/settings/file-chooser]
sort-directories-first=true
show-hidden=false
clock-format='24h'
EOF
}

configure_nautilus() {
    log_info "Configuring Nautilus..."
    
    cat >> /etc/dconf/db/local.d/06-vfs << 'EOF'

[org/gnome/nautilus/preferences]
default-folder-viewer='icon-view'
show-create-link=true
show-delete-permanently=false
recursive-search='local-only'
search-filter-time-type='last_modified'

[org/gnome/nautilus/icon-view]
default-zoom-level='medium'
captions=['size', 'type', 'date_modified']

[org/gnome/nautilus/list-view]
default-zoom-level='small'
use-tree-view=true

[org/gnome/nautilus/compression]
default-compression-format='zip'
EOF
}

setup_trash() {
    log_info "Configuring trash..."
    
    cat > /etc/systemd/user/empty-trash.service << 'EOF'
[Unit]
Description=Empty trash older than 30 days

[Service]
Type=oneshot
ExecStart=/usr/bin/find %h/.local/share/Trash/files -mtime +30 -delete
ExecStart=/usr/bin/find %h/.local/share/Trash/info -mtime +30 -delete
EOF

    cat > /etc/systemd/user/empty-trash.timer << 'EOF'
[Unit]
Description=Empty old trash weekly

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
EOF
}

configure_gvfs
configure_nautilus
setup_trash

log_info "VFS configuration complete"
