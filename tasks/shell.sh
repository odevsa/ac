#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ############################################################
# Shell and utilities
# ############################################################
install_official \
  "zsh fish lsd bat" \
  "Installing shell and utilities..."

# ############################################################
# Set default shell to fish for current user and root
# ############################################################
CHOSEN_SHELL="${1:-zsh}"
if ! command -v "$CHOSEN_SHELL" &> /dev/null; then
  CHOSEN_SHELL="zsh"
fi

log "Setting default shell for current user and root to $CHOSEN_SHELL..."

if [ "$SHELL" != "$(which $CHOSEN_SHELL)" ]; then
  sudo chsh -s "$(which $CHOSEN_SHELL)" "$USER" &> /dev/null || true
  log_sub "Set default shell for $USER to $(which $CHOSEN_SHELL)." success
else
  log_sub "Default shell for $USER is already $(which $CHOSEN_SHELL)." warning
fi

if [ "$(sudo getent passwd root | cut -d: -f7)" != "$(which $CHOSEN_SHELL)" ]; then
  sudo chsh -s "$(which $CHOSEN_SHELL)" root &> /dev/null || true
  log_sub "Set default shell for root to $(which $CHOSEN_SHELL)." success
else
  log_sub "Default shell for root is already $(which $CHOSEN_SHELL)." warning
fi

# ############################################################
# Ble.sh (Bash)
# ############################################################
log "Installing Ble.sh (Bash)..."
REPO_URL="https://github.com/akinomyoga/ble.sh.git"
TMP_DIR="/tmp/ble.sh"
DEST_DIR="/usr/share/blesh"
if [ ! -d "$DEST_DIR" ]; then
  if [ -d "$TMP_DIR" ]; then
    sudo rm -rf "$TMP_DIR" || true
    log_sub "Removed old $TMP_DIR"
  fi
  git clone --recursive --depth 1 --shallow-submodules "$REPO_URL" "$TMP_DIR" &> /dev/null || true
  sudo make -C "$TMP_DIR" install INSDIR="$DEST_DIR" &> /dev/null || true
  log_sub "Installed Ble.sh (Bash)." success
else
  log_sub "Ble.sh (Bash) is already installed." muted
fi

# ############################################################
# Antidote (ZSH)
# ############################################################
log "Installing Antidote (ZSH)..."
REPO_URL="https://github.com/mattmc3/antidote.git"
TMP_DIR="/tmp/antidote"
DEST_DIR="/usr/share/antidote"
if [ ! -d "$DEST_DIR" ]; then
  if [ -d "$TMP_DIR" ]; then
    sudo rm -rf "$TMP_DIR" || true
    log_sub "Removed old $TMP_DIR"
  fi
  git clone --depth=1 "$REPO_URL" "$TMP_DIR" &> /dev/null || true
  sudo mv "$TMP_DIR" "$DEST_DIR" &> /dev/null || true
  log_sub "Installed Antidote (ZSH)." success
else
  log_sub "Antidote (ZSH) is already installed." muted
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
