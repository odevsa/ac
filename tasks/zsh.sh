#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

TMP_DIR_ANTIGEN="/tmp/.antigen"

# ############################################################
# ZSH
# ############################################################
install_official \
  "zsh eza bat" \
  "Installing zsh and helpers..."

# ############################################################
# Set default shell to zsh for current user and root
# ############################################################
echo "=> Setting default shell for current user and root to /usr/bin/zsh..."
sudo chsh -s $(which zsh) "$USER" &> /dev/null || true
sudo chsh -s $(which zsh) root &> /dev/null || true

# ############################################################
# Install Oh My Posh
# ############################################################
echo "=> Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/bin &> /dev/null || true

# ############################################################
# Antigen
# ############################################################
echo "=> Downloading Antigen"
sudo rm -rf "$TMP_DIR_ANTIGEN"
mkdir -p "$TMP_DIR_ANTIGEN"
curl -fsSL https://git.io/antigen -o "$TMP_DIR_ANTIGEN/antigen.zsh" &> /dev/null || true

echo "=> Copying Antigen to home and root..."
mkdir -p "$HOME/.antigen"
cp -r "$TMP_DIR_ANTIGEN/." "$HOME/.antigen/" || true

sudo mkdir -p /root/.antigen
sudo cp -r "$TMP_DIR_ANTIGEN/." /root/.antigen/ || true