#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Reflector
# ###########################################################
install_official \
  "reflector" \
  "Installing reflector..."

# ###########################################################
# Reflector Service
# ###########################################################
log "Enabling and starting reflector services..."

if [ ! -f /etc/systemd/system/reflector.service ]; then
  sudo tee /etc/systemd/system/reflector.service > /dev/null <<EOL
[Unit]
Description=Pacman mirrorlist update
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

[Install]
RequiredBy=multi-user.target
EOL
  log_sub "Created /etc/systemd/system/reflector.service." success
else
  log_sub "reflector.service already exists." warning
fi

if [ ! -f /etc/systemd/system/reflector.timer ]; then
  sudo tee /etc/systemd/system/reflector.timer > /dev/null <<EOL
[Unit]
Description=Reflector weekly timer

[Timer]
OnCalendar=Mon *-*-* 7:00:00
RandomizeDelaySec=15h
Persistent=true

[Install]
WantedBy=timers.target
EOL
  sudo systemctl daemon-reload || true
  log_sub "Created /etc/systemd/system/reflector.timer." success
else
  log_sub "reflector.timer already exists." warning
fi

# ###########################################################
# Enable and start reflector services
# ###########################################################
sudo systemctl daemon-reload || true
enable_start_service "reflector.service"
enable_start_service "reflector.timer"

# ###########################################################
# Customize pacman
# ###########################################################
log "Customizing pacman..."

sudo sed -i -E 's/^[[:space:]]*#?[[:space:]]*ParallelDownloads.*$/ParallelDownloads = 10/' /etc/pacman.conf || true
log_sub "Enabled ParallelDownloads in pacman.conf." success

sudo sed -i -E 's/^[[:space:]]*#[[:space:]]*(Color.*)$/\1/' /etc/pacman.conf || true
log_sub "Enabled Color in pacman.conf." success

if sudo grep -Eq '^[[:space:]]*#?[[:space:]]*ILoveCandy' /etc/pacman.conf; then
  sudo sed -i -E 's/^[[:space:]]*#[[:space:]]*(ILoveCandy.*)$/\1/' /etc/pacman.conf || true
  log_sub "Enabled ILoveCandy in pacman.conf." success
else
  sudo sed -i -E '/^[[:space:]]*Color/ a ILoveCandy' /etc/pacman.conf || true
  log_sub "Added ILoveCandy to pacman.conf." success
fi

# ###########################################################
# General packages
# ###########################################################
log "=> Updating cache and upgrading packages..."
sudo pacman -Syuu --noconfirm &> /dev/null
log_sub "Cache updated and packages upgraded." success
