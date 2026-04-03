#!/bin/bash
set -euo pipefail

log_info() { echo "[08-gaming] $1"; }

log_info "Configuring gaming environment..."

configure_gamemode() {
    log_info "Configuring GameMode..."
    
    mkdir -p /etc/gamemode.d
    cat > /etc/gamemode.d/tahoeos.ini << 'EOF'
[general]
renice=10
ioprio=0
inhibit_screensaver=1

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0
amd_performance_level=high

[custom]
start=notify-send "GameMode" "Gaming optimizations enabled"
end=notify-send "GameMode" "Gaming optimizations disabled"
EOF
}

configure_mangohud() {
    log_info "Configuring MangoHud..."
    
    mkdir -p /etc/MangoHud
    cat > /etc/MangoHud/MangoHud.conf << 'EOF'
fps
frametime
cpu_stats
gpu_stats
ram
vram
gpu_temp
cpu_temp
font_size=20
position=top-left
toggle_fps_limit=F1
toggle_hud=F12
EOF
}

configure_gamescope() {
    log_info "Configuring Gamescope..."
    
    cat > /usr/local/bin/gamescope-session << 'EOF'
#!/bin/bash
export SDL_VIDEODRIVER=wayland
export GAMESCOPE_WAYLAND_DISPLAY="${WAYLAND_DISPLAY}"
exec gamescope -W 1920 -H 1080 -f -- "$@"
EOF
    chmod +x /usr/local/bin/gamescope-session
}

setup_proton_ge() {
    log_info "Setting up Proton-GE download helper..."
    
    cat > /usr/local/bin/install-proton-ge << 'EOF'
#!/bin/bash
STEAM_COMPAT="${HOME}/.steam/root/compatibilitytools.d"
mkdir -p "$STEAM_COMPAT"

echo "Fetching latest Proton-GE..."
LATEST=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep "browser_download_url.*tar.gz" | cut -d '"' -f 4)

if [[ -n "$LATEST" ]]; then
    wget -O /tmp/proton-ge.tar.gz "$LATEST"
    tar -xzf /tmp/proton-ge.tar.gz -C "$STEAM_COMPAT"
    rm /tmp/proton-ge.tar.gz
    echo "Proton-GE installed. Restart Steam to use it."
else
    echo "Failed to fetch Proton-GE"
    exit 1
fi
EOF
    chmod +x /usr/local/bin/install-proton-ge
}

configure_gamemode
configure_mangohud
configure_gamescope
setup_proton_ge

log_info "Gaming configuration complete"
