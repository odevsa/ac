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
echo "=> Setting Papirus as the default icon theme..."
mkdir -p ~/.config/cosmic/com.system76.CosmicTk/v1/
echo '"Papirus"' > ~/.config/cosmic/com.system76.CosmicTk/v1/icon_theme

# ###########################################################
# Folder color
# ###########################################################
echo "=> Setting folder color..."
sudo curl -Lo /usr/bin/papirus-folders https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders
sudo chmod +x /usr/bin/papirus-folders
/usr/bin/papirus-folders -C black
