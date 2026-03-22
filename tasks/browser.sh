#!/usr/bin/env bash
set -euo pipefail

BROWSER="${1:-firefox}"

# ###########################################################
# Browser
# ###########################################################

if [[ "$BROWSER" == "google-chrome" ]]; then
  echo "=> Installing browser (Google Chrome)..."
      # YAY
      # Install AUR google-chrome
      # yay -S --noconfirm google-chrome
  exit 0
fi

echo "=> Installing browsers ($BROWSER)..."
sudo pacman -S --noconfirm --needed \
  "$BROWSER" \
  &> /dev/null || true