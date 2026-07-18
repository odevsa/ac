#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# GPU Drivers Nvidia
# ###########################################################
install_official \
    "nvidia-open nvidia-utils lib32-nvidia-utils nvidia-prime nvidia-settings nvtop" \
    "Installing gpu drivers (Nvidia)..."
# ###########################################################
# Add Nvidia modules to mkinitcpio.conf
# ###########################################################
MK_FILE=/etc/mkinitcpio.conf
log "Ensuring Nvidia modules are present in $MK_FILE..."
if [ -f "$MK_FILE" ]; then
    if sudo grep -Eq '^MODULES=.*\bnvidia\b' "$MK_FILE"; then
        log_sub "'nvidia' already present in '$MK_FILE'." warning
    else
        sudo cp -a "$MK_FILE" "$MK_FILE.bak" || true
        sudo sed -E -i "s/^(MODULES=\()([^)]*)(\))/MODULES=(\2 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" "$MK_FILE"
        log_sub "Added 'nvidia' to MODULES in '$MK_FILE'." success
    fi
fi

# ###########################################################
# Modprobe configuration for Nvidia DRM
# ###########################################################
NVIDIA_FILE=/etc/modprobe.d/nvidia.conf
log "Creating modprobe configuration for Nvidia DRM in $NVIDIA_FILE..."

if [ ! -f "$NVIDIA_FILE" ]; then
    sudo tee "$NVIDIA_FILE" > /dev/null <<'EOF'
options nvidia_drm modeset=1 fbdev=1
EOF
    log_sub "Created '$NVIDIA_FILE' with Nvidia DRM options." success
else
    log_sub "'$NVIDIA_FILE' already exists." warning
fi

# ###########################################################
# Regenerate initramfs
# ###########################################################
log "Regenerating initramfs..."
sudo mkinitcpio -P &> /dev/null || true
log_sub "Regenerated initramfs..." success