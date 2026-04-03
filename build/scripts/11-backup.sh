#!/bin/bash
set -euo pipefail

log_info() { echo "[11-backup] $1"; }

log_info "Configuring backup system..."

configure_snapper() {
    log_info "Configuring Snapper for Btrfs snapshots..."
    
    mkdir -p /etc/snapper/configs
    cat > /etc/snapper/configs/root << 'EOF'
SUBVOLUME="/"
FSTYPE="btrfs"
QGROUP=""

BACKGROUND_COMPARISON="yes"
NUMBER_CLEANUP="yes"
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="10"
NUMBER_LIMIT_IMPORTANT="5"

TIMELINE_CREATE="yes"
TIMELINE_CLEANUP="yes"
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="4"
TIMELINE_LIMIT_MONTHLY="3"
TIMELINE_LIMIT_YEARLY="1"

EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"
EOF
}

configure_backup_script() {
    log_info "Creating backup helper script..."
    
    cat > /usr/local/bin/tahoe-backup << 'EOF'
#!/bin/bash
set -euo pipefail

case "${1:-}" in
    create)
        snapper create -d "Manual backup: $(date '+%Y-%m-%d %H:%M')"
        echo "Snapshot created"
        ;;
    list)
        snapper list
        ;;
    restore)
        if [[ -z "${2:-}" ]]; then
            echo "Usage: tahoe-backup restore <snapshot-number>"
            exit 1
        fi
        snapper undochange "$2"..0
        echo "Restored to snapshot $2"
        ;;
    *)
        echo "TahoeOS Backup System"
        echo "Usage: tahoe-backup <create|list|restore [number]>"
        ;;
esac
EOF
    chmod +x /usr/local/bin/tahoe-backup
}

configure_systemd_timer() {
    log_info "Setting up automatic snapshots..."
    
    mkdir -p /etc/systemd/system
    
    cat > /etc/systemd/system/tahoe-snapshot.service << 'EOF'
[Unit]
Description=TahoeOS Automatic Snapshot
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/tahoe-backup create
EOF

    cat > /etc/systemd/system/tahoe-snapshot.timer << 'EOF'
[Unit]
Description=TahoeOS Snapshot Timer

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF
}

configure_snapper
configure_backup_script
configure_systemd_timer

log_info "Backup configuration complete"
