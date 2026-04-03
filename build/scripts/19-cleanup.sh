#!/bin/bash
set -euo pipefail

log_info() { echo "[19-cleanup] $1"; }

log_info "Cleaning up build artifacts..."

cleanup_cache() {
    log_info "Cleaning package cache..."
    
    dnf clean all 2>/dev/null || true
    rm -rf /var/cache/dnf/*
    rm -rf /var/cache/yum/*
}

cleanup_logs() {
    log_info "Cleaning logs..."
    
    rm -rf /var/log/journal/*
    rm -rf /var/log/dnf.*
    rm -rf /var/log/hawkey.log
    truncate -s 0 /var/log/wtmp 2>/dev/null || true
    truncate -s 0 /var/log/lastlog 2>/dev/null || true
}

cleanup_temp() {
    log_info "Cleaning temporary files..."
    
    rm -rf /tmp/*
    rm -rf /var/tmp/*
    rm -rf /root/.cache/*
}

cleanup_machine_id() {
    log_info "Resetting machine-id..."
    
    truncate -s 0 /etc/machine-id
    rm -f /var/lib/dbus/machine-id
}

finalize() {
    log_info "Finalizing..."
    
    dconf update 2>/dev/null || true
    
    update-mime-database /usr/share/mime 2>/dev/null || true
    update-desktop-database /usr/share/applications 2>/dev/null || true
    gtk-update-icon-cache /usr/share/icons/TahoeOS 2>/dev/null || true
    
    fc-cache -f 2>/dev/null || true
}

cleanup_cache
cleanup_logs
cleanup_temp
cleanup_machine_id
finalize

log_info "Cleanup complete"
