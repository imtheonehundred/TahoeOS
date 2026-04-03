#!/bin/bash
set -euo pipefail

log_info() { echo "[04-kernel] $1"; }

log_info "Configuring kernel..."

KERNEL_PARAMS=(
    "quiet"
    "splash"
    "rd.udev.log_level=3"
    "systemd.show_status=auto"
    "rd.systemd.show_status=auto"
    "mitigations=off"
    "nowatchdog"
    "nmi_watchdog=0"
    "split_lock_detect=off"
    "clearcpuid=514"
)

echo "${KERNEL_PARAMS[*]}" > /tmp/tahoeos-kernel-params.txt

log_info "Kernel params: ${KERNEL_PARAMS[*]}"
log_info "Kernel configuration ready"
