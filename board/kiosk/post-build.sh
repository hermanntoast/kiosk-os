#!/bin/bash
#
# Kiosk OS Post-Build Script
#

set -e

BOARD_DIR="$(dirname "$0")"
TARGET_DIR="$1"

echo "=== Kiosk OS Post-Build ==="
echo "Target: $TARGET_DIR"

# Make all custom scripts executable
echo "Setting script permissions..."
chmod +x "${TARGET_DIR}/etc/init.d/S01psplash" 2>/dev/null || true
chmod +x "${TARGET_DIR}/etc/init.d/S10system" 2>/dev/null || true
chmod +x "${TARGET_DIR}/etc/X11/xinit/xinitrc" 2>/dev/null || true
chmod +x "${TARGET_DIR}/usr/bin/kiosk-browser" 2>/dev/null || true
chmod +x "${TARGET_DIR}/usr/bin/kiosk-start" 2>/dev/null || true

# Create necessary directories
echo "Creating directories..."
mkdir -p "${TARGET_DIR}/var/log"
mkdir -p "${TARGET_DIR}/var/lock"
mkdir -p "${TARGET_DIR}/var/run"
mkdir -p "${TARGET_DIR}/var/tmp"
mkdir -p "${TARGET_DIR}/tmp"
mkdir -p "${TARGET_DIR}/run"
mkdir -p "${TARGET_DIR}/tmp/.X11-unix"

# Set permissions
chmod 1777 "${TARGET_DIR}/tmp"
chmod 1777 "${TARGET_DIR}/tmp/.X11-unix"

# Create default kiosk config
echo 'KIOSK_URL="https://luxcode.io/"' > "${TARGET_DIR}/etc/kiosk.conf"

# Set hostname
echo "kiosk" > "${TARGET_DIR}/etc/hostname"

# Verify critical files exist
echo "Verifying installation..."
for f in /usr/bin/Xorg /usr/bin/xinit /usr/bin/chromium; do
    if [ -e "${TARGET_DIR}${f}" ]; then
        echo "  OK: $f"
    else
        echo "  MISSING: $f"
    fi
done

# Clean up unnecessary files to reduce image size
rm -rf "${TARGET_DIR}/usr/share/doc" 2>/dev/null || true
rm -rf "${TARGET_DIR}/usr/share/man" 2>/dev/null || true
rm -rf "${TARGET_DIR}/usr/share/info" 2>/dev/null || true

echo "=== Post-build completed ==="
