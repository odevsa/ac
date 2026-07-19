#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ############################################################
# Shell and utilities
# ############################################################
install_official \
  "fish lsd bat" \
  "Installing shell and utilities..."

# ############################################################
# Set default shell to fish for current user and root
# ############################################################
log "Setting default shell for current user and root to /usr/bin/fish..."

if [ "$SHELL" != "/usr/bin/fish" ]; then
  chsh -s $(which fish) "$USER" &> /dev/null || true
  log_sub "Set default shell for $USER to /usr/bin/fish." success
else
  log_sub "Default shell for $USER is already /usr/bin/fish." warning
fi

if [ "$(sudo getent passwd root | cut -d: -f7)" != "/usr/bin/fish" ]; then
  sudo chsh -s $(which fish) root &> /dev/null || true
  log_sub "Set default shell for root to /usr/bin/fish." success
else
  log_sub "Default shell for root is already /usr/bin/fish." warning
fi

# ############################################################
# Install Oh My Posh
# ############################################################
log "Installing Oh My Posh..."
if [ ! -f "/usr/bin/oh-my-posh" ]; then
  curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/bin &> /dev/null || true
  log_sub "Installed Oh My Posh." success
else
  log_sub "Oh My Posh is already installed." muted
fi
