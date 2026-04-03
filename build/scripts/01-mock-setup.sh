#!/bin/bash
set -euo pipefail

log_info() { echo "[01-mock-setup] $1"; }

log_info "Setting up mock environment..."

MOCK_CFG="/etc/mock/tahoeos-42-x86_64.cfg"

if [[ ! -f "$MOCK_CFG" ]]; then
    cat > "$MOCK_CFG" << 'EOF'
config_opts['root'] = 'tahoeos-42-x86_64'
config_opts['target_arch'] = 'x86_64'
config_opts['legal_host_arches'] = ('x86_64',)
config_opts['chroot_setup_cmd'] = 'install @buildsys-build'
config_opts['dist'] = 'fc42'
config_opts['extra_chroot_dirs'] = ['/run/lock']
config_opts['releasever'] = '42'
config_opts['package_manager'] = 'dnf'

config_opts['dnf.conf'] = """
[main]
keepcache=1
debuglevel=2
reposdir=/dev/null
logfile=/var/log/yum.log
retries=20
obsoletes=1
gpgcheck=0
assumeyes=1
syslog_ident=mock
syslog_device=
best=1
install_weak_deps=0
protected_packages=
module_platform_id=platform:f42
user_agent={{ user_agent }}

[fedora]
name=Fedora 42 - x86_64
metalink=https://mirrors.fedoraproject.org/metalink?repo=fedora-42&arch=x86_64
enabled=1
gpgcheck=0

[updates]
name=Fedora 42 - x86_64 - Updates
metalink=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f42&arch=x86_64
enabled=1
gpgcheck=0

[rpmfusion-free]
name=RPM Fusion for Fedora 42 - Free
metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-42&arch=x86_64
enabled=1
gpgcheck=0

[rpmfusion-nonfree]
name=RPM Fusion for Fedora 42 - Nonfree
metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-42&arch=x86_64
enabled=1
gpgcheck=0
"""
EOF
    log_info "Mock config created at $MOCK_CFG"
fi

mock -r tahoeos-42-x86_64 --init

log_info "Mock setup complete"
