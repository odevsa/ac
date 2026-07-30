#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Flatpak packages
# ###########################################################
install_official \
  "flatpak" \
  "Installing flatpak..."

# ###########################################################
# Flatpak remotes
# ###########################################################
log "Adding flatpak remotes..."
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /dev/null || true
log_sub "Flathub remote added." success
flatpak remote-add --user --if-not-exists cosmic https://apt.pop-os.org/cosmic/cosmic.flatpakrepo &> /dev/null || true
log_sub "Cosmic remote added." success