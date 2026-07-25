#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Terminal applications
# ###########################################################
install_official \
	"btop fastfetch micro" \
	"Installing terminal applications..."

# ###########################################################
# Graphical applications
# ###########################################################
install_official \
	"gnome-calculator gnome-connections gnome-disk-utility baobab cosmic-monitor snapshot simple-scan evince file-roller totem loupe" \
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
log "Creating applications.menu symlink"
if [ ! -f /etc/xdg/menus/applications.menu ]; then
	sudo ln -sf /etc/xdg/menus/gnome-applications.menu /etc/xdg/menus/applications.menu
	log_sub "Created applications.menu symlink" success
else
	log_sub "'applications.menu' symlink already exists" warning
fi