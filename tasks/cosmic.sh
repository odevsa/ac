#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Cosmic Desktop Environment
# ###########################################################
install_official \
  "cosmic power-profiles-daemon" \
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
# SSH_AUTH_SOCK configuration
# ###########################################################
log "Configuring SSH_AUTH_SOCK environment..."
sudo mkdir -p /etc/profile.d
sudo tee /etc/profile.d/ssh-agent.sh > /dev/null <<'EOF'
if [ -z "${SSH_AUTH_SOCK}" ]; then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/ssh-agent.socket"
fi
EOF
log_sub "Created /etc/profile.d/ssh-agent.sh" success

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