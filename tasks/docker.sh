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
# Add user to docker group
# ###########################################################
log "Adding current user to docker group..."
if ! groups "$USER" | grep -q "\bdocker\b"; then
  sudo usermod -aG docker "$USER" || true
  log_sub "User '$USER' added to 'docker' group successfully." success
else
  log_sub "User '$USER' is already in the 'docker' group." warning
fi

# ###########################################################
# Enable services
# ###########################################################
enable_start_service "docker"
