#!/bin/bash
#
# Kiosk OS Post-Build Script
#

set -e

BOARD_DIR="$(dirname "$0")"
TARGET_DIR="$1"

# Make scripts executable
chmod +x "${TARGET_DIR}/etc/init.d/S01psplash" 2>/dev/null || true
chmod +x "${TARGET_DIR}/etc/X11/xinit/xinitrc" 2>/dev/null || true
chmod +x "${TARGET_DIR}/usr/bin/kiosk-browser" 2>/dev/null || true
chmod +x "${TARGET_DIR}/usr/bin/kiosk-start" 2>/dev/null || true

# Create necessary directories
mkdir -p "${TARGET_DIR}/var/log"
mkdir -p "${TARGET_DIR}/tmp"
mkdir -p "${TARGET_DIR}/var/tmp"

# Create default kiosk config
echo 'KIOSK_URL="https://luxcode.io/"' > "${TARGET_DIR}/etc/kiosk.conf"

# Set hostname
echo "kiosk" > "${TARGET_DIR}/etc/hostname"

# Clean up unnecessary files to reduce image size
rm -rf "${TARGET_DIR}/usr/share/doc" 2>/dev/null || true
rm -rf "${TARGET_DIR}/usr/share/man" 2>/dev/null || true
rm -rf "${TARGET_DIR}/usr/share/info" 2>/dev/null || true

echo "Kiosk OS post-build completed!"
