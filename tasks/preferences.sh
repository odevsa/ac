#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Auto logon
# ###########################################################
GREETER_FILE="/etc/greetd/cosmic-greeter.toml"
log "Configuring auto logon..."
if ! grep -q '^\[initial_session\]' "$GREETER_FILE"; then
  sudo cp "$GREETER_FILE" "$GREETER_FILE.bak"
  log_sub "Backup of $GREETER_FILE created at $GREETER_FILE.bak"
  sudo sed -i '/^\[initial_session\]/,/^$/d' "$GREETER_FILE"
  echo -e "[initial_session]\ncommand = \"start-cosmic\"\nuser = \"$USER\"\n\n$(cat "$GREETER_FILE")" | sudo tee "$GREETER_FILE" > /dev/null
  log_sub "Auto logon configured successfully." success
else
  log_sub "Auto logon is already configured." warning
fi

# ###########################################################
# Set default image viewer to GNOME Loupe
# ###########################################################
log "Setting default image viewer to GNOME Loupe..."
xdg-mime default org.gnome.Loupe.desktop image/jpeg image/png image/gif image/webp image/bmp image/tiff image/svg+xml
log_sub "Default image viewer set to GNOME Loupe." success

# ###########################################################
# Solve bug with copying large files to external drives
# ###########################################################
log "Solving bug with copying large files to external drives..."
if ! grep -q "vm.dirty_background_bytes = 16777216" /etc/sysctl.d/99-usb-copy-fix.conf 2>/dev/null; then
  echo "vm.dirty_background_bytes = 16777216" | sudo tee -a /etc/sysctl.d/99-usb-copy-fix.conf > /dev/null
  echo "vm.dirty_bytes = 50331648" | sudo tee -a /etc/sysctl.d/99-usb-copy-fix.conf > /dev/null
  log_sub "Set vm.dirty_background_bytes and vm.dirty_bytes in /etc/sysctl.d/99-usb-copy-fix.conf." success

  sudo sysctl --system > /dev/null 2>&1 || true
  log_sub "Reloaded sysctl settings." success
else
  log_sub "USB copy fix already applied." warning
fi

# ###########################################################
# Serial port access for IoT development
# ###########################################################
log "Serial port access for IoT development..."

if ! groups $USER | grep -q "\buucp\b"; then
  sudo usermod -a -G uucp $USER
  log_sub "'$USER' added to 'uucp' group successfully." success
else
  log_sub "'$USER' is already in the 'uucp' group." warning
fi