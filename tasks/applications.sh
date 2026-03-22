#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Terminal applications
# ###########################################################
echo "=> Installing terminal applications..."
sudo pacman -S --noconfirm --needed \
	btop fastfetch nano \
	&> /dev/null

# ###########################################################
# Graphical applications
# ###########################################################
echo "=> Installing utilities..."
sudo pacman -S --noconfirm --needed \
	alacarte gnome-calculator gnome-connections gnome-disk-utility baobab gnome-system-monitor snapshot simple-scan evince file-roller totem loupe \
	&> /dev/null

# ###########################################################
# Office
# ###########################################################
echo "=> Installing libreoffice..."
sudo pacman -S --noconfirm --needed \
	libreoffice-fresh \
	&> /dev/null || true

    # YAY
    # Install AUR onlyoffice-bin
    # yay -S --noconfirm onlyoffice-bin

# ###########################################################
# Development applications
# ###########################################################
echo "=> Installing development applications..."
sudo pacman -S --noconfirm --needed \
  dbeaver \
  &> /dev/null || true

echo "=> Install Code - OSS..."
sudo pacman -S --noconfirm --needed \
  code \
  &> /dev/null || true

    # YAY
    # Install AUR visual-studio-code-bin
    # yay -S --noconfirm visual-studio-code-bin


# ###########################################################
# Graphics applications
# ###########################################################
echo "=> Installing graphics applications..."
sudo pacman -S --noconfirm --needed \
	gimp inkscape \
	&> /dev/null || true

# ###########################################################
# Multimedia applications
# ###########################################################
echo "=> Installing multimedia applications..."
sudo pacman -S --noconfirm --needed \
	audacity obs-studio kdenlive \
	&> /dev/null || true

# ###########################################################
# 3D applications
# ###########################################################
echo "=> Installing 3D applications..."
sudo pacman -S --noconfirm --needed \
	blender freecad \
	&> /dev/null || true

# ###########################################################
# 3D printing applications
# ###########################################################
echo "=> Installing 3D printing applications..."
sudo pacman -S --noconfirm --needed \
	 prusa-slicer \
	&> /dev/null || true

    # YAY
    # Install AUR orca-slicer-bin
    # yay -S --noconfirm orca-slicer-bin

# ###########################################################
# Create applications.menu symlink
# ###########################################################
echo "=> Creating applications.menu symlink"
sudo ln -sf /etc/xdg/menus/gnome-applications.menu /etc/xdg/menus/applications.menu || true