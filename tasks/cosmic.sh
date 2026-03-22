#!/usr/bin/env bash
set -euo pipefail

# ###########################################################
# Cosmic Desktop Environment
# ###########################################################
echo "=> Installing Cosmic Desktop Environment..."
sudo pacman -S --noconfirm --needed \
  cosmic power-profiles-daemon \
  &> /dev/null || true

# ###########################################################
# Enable services
# ###########################################################
echo "=> Enabling cosmic-greeter service..."
sudo systemctl enable --now cosmic-greeter &> /dev/null || true


# ###########################################################
# Enable quiet boot for Cosmic greeter
# ###########################################################
echo "=> Updating boot entries for quiet mode..."
BOOT_DIR=/boot/loader/entries
PATTERN='*linux*.conf'
if compgen -G "$BOOT_DIR/$PATTERN" > /dev/null; then
  for f in $BOOT_DIR/$PATTERN; do
    echo "=> Processing $f"
    if sudo grep -Eq '\bquiet\b' "$f"; then
      echo "   - already has 'quiet', skipping"
      continue
    fi
    sudo sed -E -i "s/^(options[[:space:]].*)$/\1 quiet loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3/" "$f" || true
  done
fi
