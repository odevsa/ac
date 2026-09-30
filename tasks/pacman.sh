#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Reflector
# ###########################################################
install_official \
  "reflector" \
  "Installing reflector..."

log "Configuring reflector..."
sudo mkdir -p /etc/xdg/reflector
sudo tee /etc/xdg/reflector/reflector.conf > /dev/null <<EOL
--save /etc/pacman.d/mirrorlist
--protocol https
--latest 10
--sort rate
EOL
log_sub "Configured /etc/xdg/reflector/reflector.conf" success

log "Updating initial pacman mirrorlist..."
sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist || true
log_sub "Mirrors updated." success

enable_start_service "reflector.timer"

# ###########################################################
# Customize pacman
# ###########################################################
log "Customizing pacman..."

sudo sed -i -E 's/^[[:space:]]*#?[[:space:]]*ParallelDownloads.*$/ParallelDownloads = 10/' /etc/pacman.conf || true
log_sub "Enabled ParallelDownloads in pacman.conf." success

sudo sed -i -E 's/^[[:space:]]*#[[:space:]]*(Color.*)$/\1/' /etc/pacman.conf || true
log_sub "Enabled Color in pacman.conf." success

if sudo grep -Eq '^[[:space:]]*#?[[:space:]]*ILoveCandy' /etc/pacman.conf; then
  sudo sed -i -E 's/^[[:space:]]*#[[:space:]]*(ILoveCandy.*)$/\1/' /etc/pacman.conf || true
  log_sub "Enabled ILoveCandy in pacman.conf." success
else
  sudo sed -i -E '/^[[:space:]]*Color/ a ILoveCandy' /etc/pacman.conf || true
  log_sub "Added ILoveCandy to pacman.conf." success
fi

# ###########################################################
# General packages
# ###########################################################
log "Updating cache and upgrading packages..."
sudo pacman -Syuu --noconfirm &> /dev/null
log_sub "Cache updated and packages upgraded." success
