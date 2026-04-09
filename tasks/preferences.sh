#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

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
