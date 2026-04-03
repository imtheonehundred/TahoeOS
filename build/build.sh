#!/bin/bash
set -euo pipefail

# TahoeOS ISO Builder - Minimal Viable Version
# Builds Fedora 42 + macOS Tahoe Theme + Gaming Stack

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[TahoeOS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${PROJECT_ROOT}/iso/output"
BUILD_DIR="/var/lib/tahoeos-build"
KICKSTART="${SCRIPT_DIR}/kickstart/tahoeos.ks"

VERSION="2026.1"

check_root() {
    [[ $EUID -eq 0 ]] || error "Run as root: sudo $0"
}

check_deps() {
    log "Checking dependencies..."
    
    local missing=()
    for cmd in lorax livemedia-creator git; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log "Installing missing: ${missing[*]}"
        dnf install -y lorax livecd-tools git pykickstart
    fi
}

validate_kickstart() {
    log "Validating kickstart..."
    ksvalidator "$KICKSTART" || warn "Kickstart validation warnings (may be OK)"
}

build_iso() {
    log "Building TahoeOS ISO..."
    log "This will take 30-60 minutes..."
    
    mkdir -p "$OUTPUT_DIR" "$BUILD_DIR"
    
    # Use livemedia-creator with --no-virt (works in VPS without KVM)
    livemedia-creator \
        --ks="$KICKSTART" \
        --no-virt \
        --resultdir="$OUTPUT_DIR" \
        --project="TahoeOS" \
        --releasever="42" \
        --volid="TahoeOS-${VERSION}" \
        --iso-only \
        --iso-name="TahoeOS-${VERSION}-x86_64.iso" \
        --tmp="$BUILD_DIR" \
        --logfile="${OUTPUT_DIR}/build.log" \
        2>&1 | tee "${OUTPUT_DIR}/livemedia.log"
    
    if [[ -f "${OUTPUT_DIR}/TahoeOS-${VERSION}-x86_64.iso" ]]; then
        log "ISO created successfully!"
        cd "$OUTPUT_DIR"
        sha256sum "TahoeOS-${VERSION}-x86_64.iso" > SHA256SUMS
        ls -lh "TahoeOS-${VERSION}-x86_64.iso"
    else
        error "ISO build failed. Check ${OUTPUT_DIR}/build.log"
    fi
}

cleanup() {
    log "Cleaning up..."
    rm -rf "$BUILD_DIR"
}

main() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║       TahoeOS ISO Builder v1.0        ║"
    echo "║   Fedora 42 + macOS Theme + Gaming    ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
    
    check_root
    check_deps
    validate_kickstart
    build_iso
    cleanup
    
    echo ""
    log "Done! ISO: ${OUTPUT_DIR}/TahoeOS-${VERSION}-x86_64.iso"
    echo ""
}

main "$@"
