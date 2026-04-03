#!/bin/bash
set -euo pipefail

log_info() { echo "[10-security] $1"; }

log_info "Configuring security..."

configure_firewall() {
    log_info "Configuring firewalld..."
    
    mkdir -p /etc/firewalld/zones
    cat > /etc/firewalld/zones/tahoeos.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>TahoeOS</short>
  <description>Default TahoeOS zone - allows SSH, mDNS, and DHCP</description>
  <service name="ssh"/>
  <service name="mdns"/>
  <service name="dhcpv6-client"/>
  <service name="samba-client"/>
</zone>
EOF
}

configure_sudo() {
    log_info "Configuring sudo..."
    
    cat > /etc/sudoers.d/tahoeos << 'EOF'
# TahoeOS sudo configuration
Defaults env_keep += "DISPLAY XAUTHORITY"
Defaults timestamp_timeout=30
%wheel ALL=(ALL) ALL
EOF
    chmod 440 /etc/sudoers.d/tahoeos
}

configure_pam() {
    log_info "Configuring PAM for fingerprint..."
    
    mkdir -p /etc/pam.d
}

disable_telemetry() {
    log_info "Disabling telemetry..."
    
    cat > /etc/profile.d/no-telemetry.sh << 'EOF'
# Disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SAM_CLI_TELEMETRY=0
export AZURE_CORE_COLLECT_TELEMETRY=0
export HOMEBREW_NO_ANALYTICS=1
export GATSBY_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1
EOF
}

configure_firewall
configure_sudo
disable_telemetry

log_info "Security configuration complete"
