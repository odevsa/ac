#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

REPO_URL="https://github.com/unlimitedbacon/stl-thumb.git"
TMP_DIR="/tmp/stl-thumb"

# ###########################################################
# STL Thumb package
# ###########################################################
if command -v stl-thumb &> /dev/null; then
	echo "=> 'stl-thumb' is already installed."
	exit 0
fi

# ###########################################################
# Dependencies packages
# ###########################################################
install_official \
	"base-devel rust git" \
	"Installing dependencies..."

# ###########################################################
# Clone repository stl-thumb
# ###########################################################
echo "=> Removing old $TMP_DIR..."
sudo rm -rf "$TMP_DIR" || true

echo "=> Cloning stl-thumb repository..."
git clone "$REPO_URL" "$TMP_DIR" &> /dev/null || true

# ###########################################################
# Build and install stl-thumb
# ###########################################################
echo "=> Building and installing stl-thumb..."
(
	cd "$TMP_DIR"
	cargo build --release
	sudo cp target/release/stl-thumb /usr/bin
) &> /dev/null || true

# ###########################################################
# Registrar o Thumbnailer
# ###########################################################
echo "=> Registering stl-thumb as a thumbnailer..."

# colocar no sudo
sudo bash -c 'cat << EOF > /usr/share/thumbnailers/stl-thumb.thumbnailer
[Thumbnailer Entry]
TryExec=stl-thumb
Exec=stl-thumb -s %s -m 666666 666666 FFFFFF %i %o
MimeType=model/stl;model/x.stl-binary;model/x.stl-ascii;application/sla;
EOF'
sudo update-mime-database /usr/share/mime