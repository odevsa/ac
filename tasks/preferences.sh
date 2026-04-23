#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Solve bug with copying large files to external drives
# ###########################################################
echo "=> Solving bug with copying large files to external drives..."
if ! grep -q "vm.dirty_background_bytes = 16777216" /etc/sysctl.d/99-usb-copy-fix.conf 2>/dev/null; then
    echo "vm.dirty_background_bytes = 16777216" | sudo tee -a /etc/sysctl.d/99-usb-copy-fix.conf > /dev/null
    echo "vm.dirty_bytes = 50331648" | sudo tee -a /etc/sysctl.d/99-usb-copy-fix.conf > /dev/null
    sudo sysctl --system > /dev/null 2>&1 || true
fi

# ###########################################################
# Serial port access for IoT development
# ###########################################################
echo "=> Serial port access for IoT development..."
sudo usermod -a -G uucp $USER

# ###########################################################
# Open Blender in window mode by default
# ###########################################################
echo "=> Setting Blender to open in window mode by default..."
if ! grep -q "Exec=blender -w" /usr/share/applications/blender.desktop; then
    sudo sed -i 's/Exec=blender/Exec=blender -w/g' /usr/share/applications/blender.desktop
fi
