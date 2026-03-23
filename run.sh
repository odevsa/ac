#!/bin/bash
set -euo pipefail
sudo -v

# ###########################################################
# Dependencies
# ###########################################################
packages=("git")
for package in "${packages[@]}"; do
  if ! pacman -Qi "$package" &> /dev/null; then
    sudo pacman -S --noconfirm --needed "$package" &> /dev/null
  fi
done

# ###########################################################
# Cloning the repository
# ###########################################################
TMP_DIR="/tmp/ac"
sudo rm -rf "$TMP_DIR"
git clone https://github.com/odevsa/ac.git "$TMP_DIR" &> /dev/null

# ###########################################################
# Run install script
# ###########################################################
(cd "$TMP_DIR" && chmod +x ./install.sh && bash ./install.sh "$@")
