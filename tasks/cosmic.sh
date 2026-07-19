#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Cosmic Desktop Environment
# ###########################################################
install_official \
  "cosmic power-profiles-daemon xdg-user-dirs" \
  "Installing Cosmic Desktop Environment..."

# ###########################################################
# Enable services
# ###########################################################
enable_service "cosmic-greeter"

# ###########################################################
# Enable quiet boot
# ###########################################################
CMDLINE_FILE="/etc/kernel/cmdline"
PARAMS="quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3 vt.global_cursor_default=0"
log "Enabling quiet boot..."
if sudo grep -Eq '\bquiet\b' "$CMDLINE_FILE"; then
  log_sub "Already has 'quiet', skipping" warning
else
  sudo sed -E -i "s/$/ $PARAMS/" "$CMDLINE_FILE" || true
  log_sub "Added 'quiet' to boot options" success
fi

# ###########################################################
# Regenerate initramfs
# ###########################################################
log "Regenerating initramfs..."
sudo mkinitcpio -P &> /dev/null || true
log_sub "Regenerated initramfs." success