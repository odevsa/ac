#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# GPU Drivers Intel
# ###########################################################
install_official \
  "mesa vulkan-intel intel-media-driver libva-intel-driver" \
  "Installing GPU drivers (Intel)..."
