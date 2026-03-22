#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Reflector
# ###########################################################  
echo "=> Installing reflector..."
sudo pacman -S --noconfirm --needed \
  reflector \
  &> /dev/null

# ###########################################################
# Reflector Service
# ###########################################################  
echo "=> Enabling and starting reflector services..."
sudo cp -r files/etc/systemd/system/. /etc/systemd/system/ || true
sudo systemctl daemon-reload || true
sudo systemctl enable --now reflector.service reflector.timer || true

# ###########################################################
# Customize pacman
# ###########################################################  
echo "=> Customizing pacman..."
sudo sed -i -E 's/^[[:space:]]*#[[:space:]]*(Color.*)$/\1/' /etc/pacman.conf || true
sudo sed -i -E 's/^[[:space:]]*#[[:space:]]*(ILoveCandy.*)$/\1/' /etc/pacman.conf || true
sudo sed -i -E 's/^[[:space:]]*#?[[:space:]]*ParallelDownloads.*$/ParallelDownloads = 10/' /etc/pacman.conf || true

# ###########################################################
# General packages
# ###########################################################  
echo "=> Updating cache and upgrading packages..."
sudo pacman -Syu --noconfirm \
  &> /dev/null
