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
  # Auto logon
  # ###########################################################
  FILE="/etc/greetd/cosmic-greeter.toml"
  log "Configuring auto logon..."
  if ! grep -q '^\[initial_session\]' "$FILE"; then
    sudo cp "$FILE" "$FILE.bak"
    log_sub "Backup of $FILE created at $FILE.bak"
    sudo sed -i '/^\[initial_session\]/,/^$/d' "$FILE"
    echo -e "[initial_session]\ncommand = \"start-cosmic\"\nuser = \"$USER\"\n\n$(cat "$FILE")" | sudo tee "$FILE" > /dev/null
    log_sub "Auto logon configured successfully." success
  else
    log_sub "Auto logon is already configured." warning
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

print_end