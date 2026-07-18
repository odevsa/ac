#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

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

# ###########################################################
# Open Blender in window mode by default
# ###########################################################
log "Setting Blender to open in window mode by default..."
if ! grep -q "Exec=blender -w" /usr/share/applications/blender.desktop; then
    sudo sed -i 's/Exec=blender/Exec=blender -w/g' /usr/share/applications/blender.desktop
    log_sub "Blender set to open in window mode." success
else
    log_sub "Blender already set to open in window mode." warning
fi
