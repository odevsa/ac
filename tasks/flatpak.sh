#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Flatpak packages
# ###########################################################
install_official \
  "flatpak" \
  "Installing flatpak..."

# ###########################################################
# Flathub remote
# ###########################################################
echo "=> Adding flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /dev/null || true
