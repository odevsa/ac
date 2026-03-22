#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# General packages
# ###########################################################  
echo "=> Installing general packages..."
sudo pacman -S --noconfirm --needed \
  curl wget usbutils gnome-keyring \
  &> /dev/null

# ###########################################################
# Audio codecs packages
# ###########################################################  
echo "=> Installing audio codecs..."
sudo pacman -S --noconfirm --needed \
  flac wavpack faac faad2 libfdk-aac a52dec libdca lame libmad libmpcdec opencore-amr opus libvorbis speex \
  &> /dev/null

# ###########################################################
# Image codecs packages
# ###########################################################  
echo "=> Installing image codecs..."
sudo pacman -S --noconfirm --needed \
  jasper libwebp libavif libheif libjxl \
  &> /dev/null

# ###########################################################
# Video codecs packages
# ###########################################################  
echo "=> Installing video codecs..."
sudo pacman -S --noconfirm --needed \
  aom dav1d rav1e svt-av1 schroedinger libdv x265 libde265 x264 libmpeg2 xvidcore libtheora libvpx \
  &> /dev/null

# ############################################################
# Gstreamer plugins packages
# ############################################################
echo "=> Installing gstreamer plugins..."
sudo pacman -S --noconfirm --needed \
  gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly \
  &> /dev/null

# ############################################################
# Archive packages
# ############################################################
echo "=> Installing archive packages..."
sudo pacman -S --noconfirm --needed \
  p7zip unrar unzip xz zip bzip2 gzip tar \
  &> /dev/null

# ############################################################
# Filesystem packages
# ############################################################
echo "=> Installing filesystem packages..."
sudo pacman -S --noconfirm --needed \
  dosfstools exfatprogs xfsprogs jfsutils f2fs-tools ntfs-3g e2fsprogs btrfs-progs \
  &> /dev/null

# ############################################################
# Hardware and system packages
# ############################################################
echo "=> Installing hardware and system packages..."
sudo pacman -S --noconfirm --needed \
  fwupd mesa vulkan-tools vulkan-intel networkmanager bluez pipewire pipewire-pulse wireplumber \
  &> /dev/null

# ############################################################
# Development packages
# ############################################################
echo "=> Installing development packages..."
sudo pacman -S --noconfirm --needed \
  base-devel git python rust nodejs-lts-iron npm \
  &> /dev/null


# ###########################################################
# Enable services
# ###########################################################  
echo "=> Enabling and starting NetworkManager services..."
sudo systemctl enable --now "NetworkManager" &> /dev/null || true

echo "=> Enabling and starting Bluetooth services..."
sudo systemctl enable --now "bluetooth" &> /dev/null || true

echo "=> Enabling and starting systemd-resolved services..."
sudo systemctl enable --now "systemd-resolved" &> /dev/null || true
