#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Neovim
# ###########################################################
install_official \
  "neovim" \
  "Installing Neovim..."

# ###########################################################
# NvChad
# ###########################################################
echo "=> Removing old Neovim configuration..."
sudo rm -rf ~/.config/nvim || true

echo "=> Setting up NvChad..."
git clone https://github.com/NvChad/starter ~/.config/nvim &> /dev/null || true
