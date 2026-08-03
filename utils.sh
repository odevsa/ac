#!/bin/bash
set -euo pipefail
source "helpers.sh"
sudo -v

# TODO
# - Menu Para escolher
# - Persistir layout do teclado

print_header "Utilities" info
print_start

  # ###########################################################
  # KVM
  # ###########################################################
  log "Verifying KVM..."
  if ! systemctl is-enabled --quiet libvirtd; then
    install_official \
      "qemu-base libvirt dnsmasq iptables-nft base-devel dmidecode" \
      "Installing KVM..."
    sudo usermod -aG kvm,libvirt $USER || true
    log_sub "'$USER' added to 'kvm,libvirt' group successfully." success
    enable_start_service "libvirtd"    
  else
    log_sub "KVM is already installed." warning
  fi

  # ###########################################################
  # Android Emulator .desktop file
  # ###########################################################
  log "Creating Android Emulator .desktop file..."
  QUESTION="Enter the name of the AVD (default: Default)"
  AVD_NAME=$(ask "$QUESTION" "warning" "Default")
  asked_rewrite $QUESTION "$AVD_NAME"
  DESKTOP_FILE="$HOME/.local/share/applications/android-emulator-${AVD_NAME,,}.desktop"
  cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Emulator ($AVD_NAME)
Comment=Iniciar emulador Android $AVD_NAME via KVM
Exec=bash -c "$HOME/Android/Sdk/emulator/emulator -avd $AVD_NAME; $HOME/Android/Sdk/platform-tools/adb kill-server"
Icon=phone
Terminal=false
Categories=Development;
EOF

  # ###########################################################
  # Add mesh as default 3D viewer
  # ###########################################################
  log "Adding mesh as default 3D viewer..."
  for mime in model/stl model/obj image/x-tga model/gltf+json model/gltf-binary; do
      xdg-mime default mesh.desktop $mime
  done
  
print_end