#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Fonts
# ###########################################################
echo "=> Installing fonts..."
sudo pacman -S --noconfirm --needed \
	ttf-font-awesome ttf-firacode-nerd ttf-iosevka-nerd noto-fonts-emoji noto-fonts-cjk noto-fonts-extra \
	&> /dev/null