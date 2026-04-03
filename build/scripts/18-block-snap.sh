#!/bin/bash
set -euo pipefail

log_info() { echo "[18-block-snap] $1"; }

log_info "Blocking Snap packages..."

block_snapd() {
    log_info "Preventing snapd installation..."
    
    mkdir -p /etc/dnf/plugins.d
    cat > /etc/dnf/plugins.d/no-snap.conf << 'EOF'
[main]
enabled=1

[exclude]
snapd
snapd-selinux
snap-confine
EOF

    cat > /etc/yum.repos.d/snapd-block.repo << 'EOF'
[snapd-block]
name=Block Snapd
enabled=0
EOF

    if command -v dnf &>/dev/null; then
        dnf config-manager --save --setopt=exclude=snapd,snapd-selinux,snap-confine 2>/dev/null || true
    fi
}

remove_snap_references() {
    log_info "Removing snap references..."
    
    cat > /etc/profile.d/no-snap.sh << 'EOF'
# TahoeOS: Snap is not supported
# Use Flatpak instead: flatpak install <app>
unset SNAP
EOF
}

block_snapd
remove_snap_references

log_info "Snap blocking complete"
