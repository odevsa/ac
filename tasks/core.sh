#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# General packages
# ###########################################################
install_official \
  "curl wget usbutils" \
  "Installing general packages..."

# ###########################################################
# Audio codecs packages
# ###########################################################
install_official \
  "flac wavpack faac faad2 libfdk-aac a52dec libdca lame libmad libmpcdec opencore-amr opus libvorbis speex" \
  "Installing audio codecs..."

# ###########################################################
# Image codecs packages
# ###########################################################
install_official \
  "jasper libwebp libavif libheif libjxl" \
  "Installing image codecs..."

# ###########################################################
# Video codecs packages
# ###########################################################
install_official \
  "aom dav1d rav1e svt-av1 schroedinger libdv x265 libde265 x264 libmpeg2 xvidcore libtheora libvpx" \
  "Installing video codecs..."

# ############################################################
# Gstreamer plugins packages
# ############################################################
install_official \
  "gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-good gst-plugins-ugly" \
  "Installing gstreamer plugins..."

# ############################################################
# Archive packages
# ############################################################
install_official \
  "p7zip unrar unzip xz zip bzip2 gzip tar" \
  "Installing archive packages..."

# ############################################################
# Filesystem packages
# ############################################################
install_official \
  "dosfstools exfatprogs xfsprogs jfsutils f2fs-tools ntfs-3g e2fsprogs btrfs-progs" \
  "Installing filesystem packages..."

# ############################################################
# Hardware and system packages
# ############################################################
install_official \
  "xdg-user-dirs fwupd mesa vulkan-tools vulkan-intel networkmanager bluez bluez-utils pipewire pipewire-pulse wireplumber wl-clipboard" \
  "Installing hardware and system packages..."

# ############################################################
# Development packages
# ############################################################
install_official \
  "base-devel cmake git python rust nodejs-lts-iron npm" \
  "Installing development packages..."

# ############################################################
# User directories
# ############################################################
log "Creating user directories..."
xdg-user-dirs-update &> /dev/null || true
rm -rf "$HOME/Projects" &> /dev/null || true
xdg-user-dirs-update &> /dev/null || true
log_sub "Created user directories" success

# ###########################################################
# Enable services
# ###########################################################
enable_start_service "NetworkManager"

enable_start_service "bluetooth"

enable_start_service "systemd-resolved"
