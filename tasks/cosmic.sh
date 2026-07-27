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
# Fixing SSH_AUTH_SOCK missing issue
# ###########################################################
log "Fixing SSH_AUTH_SOCK missing issue..."
if ! grep -q 'SSH_AUTH_SOCK=' /etc/environment; then
  echo 'SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"' | sudo tee -a /etc/environment > /dev/null
  log_sub "Added SSH_AUTH_SOCK to /etc/environment" success
else
  log_sub "SSH_AUTH_SOCK already set in /etc/environment, skipping" warning
fi

# ############################################################
# Disable watchdog
# ###########################################################
log "Disabling watchdog..."
if ! grep -q 'blacklist iTCO_wdt' /etc/modprobe.d/blacklist-watchdog.conf 2>/dev/null; then
  cat <<EOF | sudo tee /etc/modprobe.d/blacklist-watchdog.conf &> /dev/null || true
blacklist iTCO_wdt
blacklist iTCO_vendor_support
blacklist intel_oc_wdt
blacklist sp5100_tco
blacklist watchdog
EOF
  log_sub "Disabled watchdog" success
else
  log_sub "Watchdog already disabled, skipping" warning
fi

# ###########################################################
# Regenerate initramfs
# ###########################################################
log "Regenerating initramfs..."
sudo mkinitcpio -P &> /dev/null || true
log_sub "Regenerated initramfs." success