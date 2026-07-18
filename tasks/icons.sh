#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Icons
# ###########################################################
install_official \
	"papirus-icon-theme" \
	"Installing icons..."

# ###########################################################
# Set Papirus as the default icon theme
# ###########################################################
log "Setting Papirus as the default icon theme..."
if [ ! -f ~/.config/cosmic/com.system76.CosmicTk/v1/icon_theme ] || ! grep -q '"Papirus"' ~/.config/cosmic/com.system76.CosmicTk/v1/icon_theme; then
	mkdir -p ~/.config/cosmic/com.system76.CosmicTk/v1/
	echo '"Papirus"' > ~/.config/cosmic/com.system76.CosmicTk/v1/icon_theme
	log_sub "Set Papirus as the default icon theme." success
else
	log_sub "Papirus is already set as the default icon theme." muted
fi

# ###########################################################
# Folder color
# ###########################################################
log "Setting folder color..."
if [ ! -f "/usr/bin/papirus-folders" ]; then
	sudo curl -Lo /usr/bin/papirus-folders https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders &> /dev/null || true
	log_sub "Installed papirus-folders script." success
	sudo chmod +x /usr/bin/papirus-folders &> /dev/null || true
else
	log_sub "papirus-folders script is already installed." muted
fi
/usr/bin/papirus-folders -C black &> /dev/null || true
log_sub "Set folder color to black." success