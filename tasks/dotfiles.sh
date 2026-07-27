#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

REPO_URL="https://github.com/odevsa/dotfiles.git"
TMP_DIR=/tmp/dotfiles

# ###########################################################
# Dependencies packages
# ###########################################################
install_official \
	"git" \
	"Verifying dependencies..." \
	true

# ###########################################################
# Clone repository dotfiles
# ###########################################################
log "Cloning dotfiles repository to '$TMP_DIR'..."

if [ -d "$TMP_DIR" ]; then
	sudo rm -rf "$TMP_DIR" || true
	log_sub "Removed old $TMP_DIR"
fi

git clone "$REPO_URL" "$TMP_DIR" &> /dev/null || true
log_sub "Cloned dotfiles repository" success

# ###########################################################
# Replace {user} placeholders
# ###########################################################
log "Replacing {user} placeholders..."
find "$TMP_DIR" -type f -exec sed -i "s/{user}/$USER/g" '{}' \; || true
log_sub "Replaced {user} placeholders to '$USER'." success

# ############################################################
# Copy dotfiles to home
# ############################################################
log "Copying dotfiles to '$HOME'..."

cp -r "$TMP_DIR/." "$HOME/" || true
log_sub "Copied dotfiles to '$HOME'." success

(cd "$HOME" && sudo rm -rf ~/.git ~/install.sh ~/README.md) || true
log_sub "Removed unnecessary files from '$HOME'." success

# ############################################################
# Copy dotfiles to root
# ############################################################
log "Copying fish and oh-my-posh to /root..."

sudo cp "$TMP_DIR/.zshrc" /root/ || true
log_sub "Copied zsh configuration to '/root'." success

sudo mkdir -p /root/.config/fish
sudo cp -r "$TMP_DIR/.config/fish/." /root/.config/fish/ || true
log_sub "Copied fish configuration to '/root'." success

sudo cp "$TMP_DIR/.bashrc" /root/ || true
log_sub "Copied bash configuration to '/root'." success

sudo mkdir -p /root/.config/oh-my-posh
sudo cp -r "$TMP_DIR/.config/oh-my-posh/." /root/.config/oh-my-posh/ || true
log_sub "Copied oh-my-posh configuration to '/root'." success