#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# GPU Drivers AMD
# ###########################################################  
echo "=> Installing gpu drivers (AMD)..."
sudo pacman -S --noconfirm --needed \
	vulkan-radeon libva-mesa-driver mesa radeontop \
	&> /dev/null