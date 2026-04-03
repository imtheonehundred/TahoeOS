#!/bin/bash
set -e

cat > /etc/sysctl.d/99-tahoeos.conf << 'EOF'
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=10
vm.dirty_background_ratio=5

net.core.netdev_max_backlog=16384
net.core.somaxconn=8192
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0

kernel.kptr_restrict=2
kernel.dmesg_restrict=1
net.ipv4.conf.all.rp_filter=1

kernel.nmi_watchdog=0

vm.max_map_count=2147483642
EOF

sysctl --system

GRUB_CFG="/etc/default/grub"
if grep -q "GRUB_CMDLINE_LINUX_DEFAULT" "$GRUB_CFG"; then
    sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off nowatchdog"/' "$GRUB_CFG"
else
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off nowatchdog"' >> "$GRUB_CFG"
fi

grub2-mkconfig -o /boot/grub2/grub.cfg 2>/dev/null || \
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg 2>/dev/null || true

echo "tahoe-kernel-config installed"
