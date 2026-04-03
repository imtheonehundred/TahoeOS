#!/bin/bash
set -euo pipefail

log_info() { echo "[15-accessibility] $1"; }

log_info "Configuring accessibility..."

configure_a11y() {
    log_info "Setting up accessibility options..."
    
    mkdir -p /etc/dconf/db/local.d
    cat > /etc/dconf/db/local.d/07-a11y << 'EOF'
[org/gnome/desktop/interface]
enable-hot-corners=false
toolkit-accessibility=false

[org/gnome/desktop/a11y]
always-show-universal-access-status=false

[org/gnome/desktop/a11y/applications]
screen-keyboard-enabled=false
screen-reader-enabled=false
screen-magnifier-enabled=false

[org/gnome/desktop/a11y/keyboard]
enable=false
bouncekeys-enable=false
slowkeys-enable=false
stickykeys-enable=false
togglekeys-enable=false

[org/gnome/desktop/a11y/mouse]
dwell-click-enabled=false
secondary-click-enabled=false
EOF
}

configure_input() {
    log_info "Configuring input devices..."
    
    cat > /etc/dconf/db/local.d/08-input << 'EOF'
[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true
natural-scroll=true
two-finger-scrolling-enabled=true
click-method='fingers'
disable-while-typing=true

[org/gnome/desktop/peripherals/mouse]
natural-scroll=false
accel-profile='adaptive'

[org/gnome/desktop/peripherals/keyboard]
delay=250
repeat-interval=30
EOF
}

configure_night_light() {
    log_info "Configuring Night Light..."
    
    cat >> /etc/dconf/db/local.d/07-a11y << 'EOF'

[org/gnome/settings-daemon/plugins/color]
night-light-enabled=true
night-light-schedule-automatic=true
night-light-temperature=3500
EOF
}

configure_a11y
configure_input
configure_night_light

log_info "Accessibility configuration complete"
