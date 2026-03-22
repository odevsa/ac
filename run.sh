#!/bin/bash
set -euo pipefail
sudo -v

# ###########################################################
# Dependencies
# ###########################################################
packages=("git")
for package in "${packages[@]}"; do
  if ! pacman -Qi "$package" &> /dev/null; then
    echo "=> Installing $package..."
    sudo pacman -S --noconfirm --needed "$package" &> /dev/null
  else
    echo "=> $package already installed."
  fi
done

# ###########################################################
# Cloning the repository
# ###########################################################
TMP_DIR="/tmp/ac"
echo "=> Cloning into $TMP_DIR..."
sudo rm -rf "$TMP_DIR"
git clone https://github.com/odevsa/ac.git "$TMP_DIR" &> /dev/null

chmod +x "$TMP_DIR/install.sh"
(cd "$TMP_DIR" && bash ./install.sh "$@")
