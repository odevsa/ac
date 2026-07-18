#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

REPO_URL="https://github.com/odevsa/dotfiles.git"
TMP_DIR=/tmp/dotfiles

# ###########################################################
# Dependencies packages
# ###########################################################
install_official \
	"git" \
	"Installing dependencies..."

# ###########################################################
# Clone repository dotfiles
# ###########################################################
echo "=> Removing old $TMP_DIR..."
sudo rm -rf "$TMP_DIR" || true

echo "=> Cloning dotfiles repository..."
git clone "$REPO_URL" "$TMP_DIR" &> /dev/null || true

# ###########################################################
# Replace {user} placeholders
# ###########################################################
echo "=> Replacing {user} placeholders..."
find "$TMP_DIR" -type f -exec sed -i "s/{user}/$USER/g" '{}' \; || true

# ############################################################
# Copy dotfiles to home
# ############################################################
echo "=> Copying dotfiles to home..."
cp -r "$TMP_DIR/." "$HOME/" || true
(cd "$HOME" && sudo rm -rf ~/.git ~/install.sh ~/README.md) || true

# ############################################################
# Copy dotfiles to root
# ############################################################
echo "=> Copying fish and oh-my-posh to root..."
sudo mkdir -p /root/.config/fish
sudo cp -r "$TMP_DIR/.config/fish/." /root/.config/fish/ || true
sudo mkdir -p /root/.config/oh-my-posh
sudo cp -r "$TMP_DIR/.config/oh-my-posh/." /root/.config/oh-my-posh/ || true