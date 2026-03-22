#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Flatpak packages
# ###########################################################
echo "=> Installing flatpak..."
sudo pacman -S --noconfirm --needed \
  flatpak \
  &> /dev/null

# ###########################################################
# Flathub remote
# ###########################################################
echo "=> Adding flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /dev/null || true
