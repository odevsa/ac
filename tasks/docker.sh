#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Docker
# ###########################################################
install_official \
  "docker docker-compose" \
  "Installing Docker and docker-compose..."

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
