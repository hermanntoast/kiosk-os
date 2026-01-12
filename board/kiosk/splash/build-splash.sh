#!/bin/bash
#
# Build custom psplash image
#
# Usage: ./build-splash.sh <buildroot-dir> <splash-image.png>
#

set -e

BUILDROOT_DIR="$1"
SPLASH_IMAGE="$2"

if [ -z "$BUILDROOT_DIR" ] || [ -z "$SPLASH_IMAGE" ]; then
    echo "Usage: $0 <buildroot-dir> <splash-image.png>"
    echo "Example: $0 ./buildroot ./board/kiosk/splash/logo.png"
    exit 1
fi

if [ ! -f "$SPLASH_IMAGE" ]; then
    echo "Error: Splash image not found: $SPLASH_IMAGE"
    exit 1
fi

PSPLASH_DIR="$BUILDROOT_DIR/output/build/psplash-0.1"

if [ ! -d "$PSPLASH_DIR" ]; then
    echo "Error: psplash build directory not found. Run 'make' first."
    echo "Expected: $PSPLASH_DIR"
    exit 1
fi

echo "Converting splash image: $SPLASH_IMAGE"

# Convert image to psplash header
cd "$PSPLASH_DIR"

# Use the psplash image converter
if [ -f "./psplash-write-image" ]; then
    ./psplash-write-image "$SPLASH_IMAGE" PSPLASH_IMG > psplash-image.h
    echo "Generated psplash-image.h"
else
    # Fallback: use GDK-pixbuf based converter from source
    if command -v gdk-pixbuf-csource &> /dev/null; then
        gdk-pixbuf-csource --struct --name=PSPLASH_IMG "$SPLASH_IMAGE" > psplash-image.h
        echo "Generated psplash-image.h using gdk-pixbuf-csource"
    else
        echo "Error: No image converter available"
        exit 1
    fi
fi

echo "Splash image successfully integrated!"
echo "Run 'make psplash-rebuild && make' to rebuild with new splash."
