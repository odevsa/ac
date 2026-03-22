#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

SKIP_AUR_HELPER=false

for arg in "$@"; do
    case $arg in
        --skip-aur-helper)
            SKIP_AUR_HELPER=true
            ;;
        *)
    esac
done

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
	"alacarte gnome-calculator gnome-connections gnome-disk-utility baobab gnome-system-monitor snapshot simple-scan evince file-roller totem loupe" \
	"Installing graphical applications..."

# ###########################################################
# Office
# ###########################################################
install_official_or_aur $SKIP_AUR_HELPER "libreoffice-fresh" "onlyoffice-bin"


# ###########################################################
# Development applications
# ###########################################################
install_official \
	"dbeaver" \
	"Installing development applications..."

install_official_or_aur $SKIP_AUR_HELPER "code" "visual-studio-code-bin"

# ###########################################################
# Graphics applications
# ###########################################################
install_official \
	"gimp inkscape" \
	"Installing graphics applications..."

# ###########################################################
# Multimedia applications
# ###########################################################
install_official \
	"audacity obs-studio kdenlive" \
	"Installing multimedia applications..."

# ###########################################################
# 3D applications
# ###########################################################
install_official \
	"blender freecad" \
	"Installing 3D applications..."

# ###########################################################
# 3D printing applications
# ###########################################################
install_official_or_aur $SKIP_AUR_HELPER "prusa-slicer" "orca-slicer-bin"

# ###########################################################
# Create applications.menu symlink
# ###########################################################
echo "=> Creating applications.menu symlink"
sudo ln -sf /etc/xdg/menus/gnome-applications.menu /etc/xdg/menus/applications.menu || true