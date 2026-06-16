#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

TMP_DIR_ANTIGEN="/tmp/.antigen"

# ############################################################
# Shell and helpers
# ############################################################
install_official \
  "fish lsd bat" \
  "Installing shell and helpers..."

# ############################################################
# Set default shell to fish for current user and root
# ############################################################
echo "=> Setting default shell for current user and root to /usr/bin/fish..."
sudo chsh -s $(which fish) "$USER" &> /dev/null || true
sudo chsh -s $(which fish) root &> /dev/null || true

# ############################################################
# Install Oh My Posh
# ############################################################
echo "=> Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/bin &> /dev/null || true
