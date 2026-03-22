#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Docker
# ###########################################################
echo "=> Installing Docker and docker-compose..."
sudo pacman -S --noconfirm --needed \
  docker docker-compose \
  &> /dev/null

# ###########################################################
# Enable services
# ###########################################################
echo "=> Enabling and starting Docker service..."
sudo systemctl enable --now docker &> /dev/null || true

# ###########################################################
# Add user to docker group
# ###########################################################
echo "=> Adding current user to docker group..."
sudo usermod -aG docker "$USER" || true
