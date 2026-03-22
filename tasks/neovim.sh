#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Neovim
# ###########################################################
echo "=> Installing Neovim..."
sudo pacman -S --noconfirm --needed \
  neovim \
  &> /dev/null

# ###########################################################
# NvChad
# ###########################################################
echo "=> Removing old Neovim configuration..."
sudo rm -rf ~/.config/nvim || true

echo "=> Setting up NvChad..."
git clone https://github.com/NvChad/starter ~/.config/nvim &> /dev/null || true
