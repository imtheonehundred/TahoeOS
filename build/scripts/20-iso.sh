#!/bin/bash
set -euo pipefail

log_info() { echo "[20-iso] $1"; }

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/iso/build"
OUTPUT_DIR="${PROJECT_ROOT}/iso/output"
KICKSTART="${PROJECT_ROOT}/build/kickstart/tahoeos.ks"

VERSION="2026.1"
RELEASE_NAME="TahoeOS"
ARCH="x86_64"

log_info "Building final ISO..."

mkdir -p "$OUTPUT_DIR"

log_info "Running livemedia-creator..."

livemedia-creator \
    --ks="$KICKSTART" \
    --no-virt \
    --make-iso \
    --project="$RELEASE_NAME" \
    --releasever="$VERSION" \
    --volid="${RELEASE_NAME}-${VERSION}" \
    --iso-only \
    --iso-name="${RELEASE_NAME}-${VERSION}-${ARCH}.iso" \
    --resultdir="$OUTPUT_DIR" \
    --logfile="${OUTPUT_DIR}/livemedia.log" \
    --tmp="${BUILD_DIR}/tmp" \
    || {
        log_info "livemedia-creator failed, trying lorax directly..."
        
        lorax \
            --product="$RELEASE_NAME" \
            --version="$VERSION" \
            --release="$VERSION" \
            --source="https://download.fedoraproject.org/pub/fedora/linux/releases/42/Everything/x86_64/os/" \
            --volid="$RELEASE_NAME" \
            --nomacboot \
            --noupgrade \
            --isfinal \
            --logfile="${OUTPUT_DIR}/lorax.log" \
            "${BUILD_DIR}/lorax-out"
    }

if ls "${OUTPUT_DIR}"/*.iso &>/dev/null; then
    log_info "Creating checksums..."
    cd "$OUTPUT_DIR"
    sha256sum *.iso > SHA256SUMS
    
    ISO_SIZE=$(du -h *.iso | cut -f1)
    log_info "ISO created successfully!"
    log_info "Size: $ISO_SIZE"
    log_info "Location: ${OUTPUT_DIR}/"
else
    log_info "ERROR: No ISO file found!"
    exit 1
fi
