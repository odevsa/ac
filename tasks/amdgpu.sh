#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# GPU Drivers AMD
# ###########################################################
install_official \
	"vulkan-radeon libva-mesa-driver mesa radeontop" \
	"Installing gpu drivers (AMD)..."