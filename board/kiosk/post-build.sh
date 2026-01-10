#!/bin/bash
#
# Kiosk OS Post-Build Script
#

set -e

BOARD_DIR="$(dirname "$0")"
TARGET_DIR="$1"

# Make init scripts executable
chmod +x "${TARGET_DIR}/etc/init.d/S99kiosk" 2>/dev/null || true
chmod +x "${TARGET_DIR}/etc/X11/xinit/xinitrc" 2>/dev/null || true
chmod +x "${TARGET_DIR}/usr/bin/kiosk-browser" 2>/dev/null || true

# Create necessary directories
mkdir -p "${TARGET_DIR}/var/log"
mkdir -p "${TARGET_DIR}/tmp"

# Create default kiosk config if not exists
if [ ! -f "${TARGET_DIR}/etc/kiosk.conf" ]; then
    echo 'KIOSK_URL="https://example.com"' > "${TARGET_DIR}/etc/kiosk.conf"
fi

# Set hostname
echo "kiosk" > "${TARGET_DIR}/etc/hostname"

# Configure auto-login for tty1 (optional, X starts via init script)
mkdir -p "${TARGET_DIR}/etc/inittab.d"

# Disable other ttys to save resources
if [ -f "${TARGET_DIR}/etc/inittab" ]; then
    sed -i 's/^tty2:/#tty2:/g' "${TARGET_DIR}/etc/inittab"
    sed -i 's/^tty3:/#tty3:/g' "${TARGET_DIR}/etc/inittab"
    sed -i 's/^tty4:/#tty4:/g' "${TARGET_DIR}/etc/inittab"
    sed -i 's/^tty5:/#tty5:/g' "${TARGET_DIR}/etc/inittab"
    sed -i 's/^tty6:/#tty6:/g' "${TARGET_DIR}/etc/inittab"
fi

# Clean up unnecessary files to reduce image size
rm -rf "${TARGET_DIR}/usr/share/doc" 2>/dev/null || true
rm -rf "${TARGET_DIR}/usr/share/man" 2>/dev/null || true
rm -rf "${TARGET_DIR}/usr/share/info" 2>/dev/null || true

echo "Kiosk OS post-build completed!"
