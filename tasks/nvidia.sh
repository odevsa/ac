#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# GPU Drivers Nvidia
# ###########################################################  
echo "=> Installing gpu drivers (Nvidia)..."
sudo pacman -S --noconfirm --needed \
	nvidia-open nvidia-utils lib32-nvidia-utils nvidia-prime nvidia-settings nvtop \
	&> /dev/null

# #############################################################
# Add Nvidia modules to mkinitcpio.conf
# #############################################################
MK_FILE=/etc/mkinitcpio.conf
echo "=> Ensuring Nvidia modules are present in $MK_FILE..."
if [ -f "$MK_FILE" ]; then
    if sudo grep -Eq '^MODULES=.*\bnvidia\b' "$MK_FILE"; then
        echo "   - 'nvidia' already present in MODULES, skipping"
    else
        sudo cp -a "$MK_FILE" "$MK_FILE.bak" || true
        sudo sed -E -i "s/^(MODULES=\()([^)]*)(\))/MODULES=(\2 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" "$MK_FILE"
    fi
fi

# ###########################################################
# Modprobe configuration for Nvidia DRM
# ###########################################################
NVIDIA_FILE=/etc/modprobe.d/nvidia.conf
echo "=> Creating modprobe configuration for Nvidia DRM in $NVIDIA_FILE..."
sudo tee "$NVIDIA_FILE" > /dev/null <<'EOF'
options nvidia_drm modeset=1 fbdev=1
EOF

# ###########################################################
# Regenerate initramfs to apply changes
# ###########################################################
echo "=> Regenerating initramfs..."
sudo mkinitcpio -P &> /dev/null || true
