#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Fonts
# ###########################################################
install_official \
	"ttf-font-awesome ttf-firacode-nerd ttf-iosevka-nerd noto-fonts-emoji noto-fonts-cjk noto-fonts-extra" \
	"Installing fonts..."

# ###########################################################
# Update font cache
# ###########################################################
log "Updating font cache..."
fc-cache -f &> /dev/null || true
log_sub "Font cache updated successfully." success
