#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

REPO_URL="https://aur.archlinux.org/yay.git"
TMP_DIR="/tmp/yay"

# ###########################################################
# Yay package
# ###########################################################
if command -v yay &> /dev/null; then
	echo "=> 'yay' is already installed."
	exit 0
fi

# ###########################################################
# Dependencies packages
# ###########################################################
install_official \
	"base-devel git" \
	"Installing dependencies for building AUR packages..."

# ###########################################################
# Clone repository yay
# ###########################################################
echo "=> Removing old $TMP_DIR..."
sudo rm -rf "$TMP_DIR" || true

echo "=> Cloning yay repository..."
git clone "$REPO_URL" "$TMP_DIR" &> /dev/null || true

# ###########################################################
# Build and install yay
# ###########################################################
echo "=> Building and installing YAY..."
(
	cd "$TMP_DIR"
	makepkg -si --noconfirm
) &> /dev/null || true
