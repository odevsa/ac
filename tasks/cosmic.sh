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
echo "=> Enabling cosmic-greeter service..."
sudo systemctl enable cosmic-greeter &> /dev/null || true


# ###########################################################
# Enable quiet boot
# ###########################################################
CMDLINE_FILE="/etc/kernel/cmdline"
PARAMS="quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3 vt.global_cursor_default=0"
echo "=> Enabling quiet boot..."
if sudo grep -Eq '\bquiet\b' "$CMDLINE_FILE"; then
  echo "   - already has 'quiet', skipping"
else
  sudo sed -E -i "s/$/ $PARAMS/" "$CMDLINE_FILE" || true
  sudo mkinitcpio -P &> /dev/null || true
  echo "   - added 'quiet' to boot options"
fi