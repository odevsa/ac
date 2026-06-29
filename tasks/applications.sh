#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Terminal applications
# ###########################################################
install_official \
	"btop fastfetch nano" \
	"Installing terminal applications..."

# ###########################################################
# Graphical applications
# ###########################################################
install_official \
	"alacarte gnome-calculator gnome-connections gnome-disk-utility baobab cosmic-monitor snapshot simple-scan evince file-roller totem loupe" \
	"Installing graphical applications..."

# ###########################################################
# Graphics applications
# ###########################################################
install_official \
	"gimp inkscape" \
	"Installing graphics applications..."

# ###########################################################
# 3D applications
# ###########################################################
install_official \
	"blender freecad" \
	"Installing 3D applications..."

# ###########################################################
# Create applications.menu symlink
# ###########################################################
echo "=> Creating applications.menu symlink"
sudo ln -sf /etc/xdg/menus/gnome-applications.menu /etc/xdg/menus/applications.menu || true