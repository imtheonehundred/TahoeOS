#!/bin/bash
set -e

cp src/tahoe-gpu-manager.py /usr/bin/tahoe-gpu-manager
chmod +x /usr/bin/tahoe-gpu-manager

echo "tahoe-gpu-manager installed"
