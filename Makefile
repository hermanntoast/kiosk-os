# Kiosk OS Build Makefile
#
# Usage:
#   make menuconfig  - Configure Buildroot
#   make             - Build the image
#   make clean       - Clean build artifacts
#
# The resulting ISO will be in buildroot/output/images/

BUILDROOT_DIR := $(CURDIR)/buildroot
BR2_EXTERNAL := $(CURDIR)
DEFCONFIG := kiosk_x86_64_defconfig

.PHONY: all defconfig menuconfig build clean distclean help

all: build

# Apply our default configuration
defconfig:
	$(MAKE) -C $(BUILDROOT_DIR) BR2_EXTERNAL=$(BR2_EXTERNAL) $(DEFCONFIG)

# Interactive configuration
menuconfig: defconfig
	$(MAKE) -C $(BUILDROOT_DIR) BR2_EXTERNAL=$(BR2_EXTERNAL) menuconfig

# Save current configuration
savedefconfig:
	$(MAKE) -C $(BUILDROOT_DIR) BR2_EXTERNAL=$(BR2_EXTERNAL) savedefconfig BR2_DEFCONFIG=$(BR2_EXTERNAL)/configs/$(DEFCONFIG)

# Build the image
build: defconfig
	$(MAKE) -C $(BUILDROOT_DIR) BR2_EXTERNAL=$(BR2_EXTERNAL)

# Clean build output (keeps downloads)
clean:
	$(MAKE) -C $(BUILDROOT_DIR) clean

# Full clean including downloads
distclean:
	$(MAKE) -C $(BUILDROOT_DIR) distclean

# Show build info
info:
	@echo "Buildroot directory: $(BUILDROOT_DIR)"
	@echo "External directory:  $(BR2_EXTERNAL)"
	@echo "Default config:      $(DEFCONFIG)"
	@echo ""
	@echo "After build, ISO will be at:"
	@echo "  $(BUILDROOT_DIR)/output/images/rootfs.iso9660"

help:
	@echo "Kiosk OS Build System"
	@echo ""
	@echo "Targets:"
	@echo "  make defconfig    - Apply default kiosk configuration"
	@echo "  make menuconfig   - Interactive configuration"
	@echo "  make savedefconfig- Save current config to defconfig"
	@echo "  make build        - Build the complete image"
	@echo "  make              - Same as 'make build'"
	@echo "  make clean        - Clean build (keeps downloads)"
	@echo "  make distclean    - Full clean including downloads"
	@echo "  make info         - Show build information"
	@echo ""
	@echo "Boot the ISO with kernel parameter:"
	@echo "  kiosk_url=https://your-url.com"
