#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

REPO_URL_VIEWER="https://github.com/fstl-app/fstl.git"
TMP_DIR_VIEWER="/tmp/fstl"
REPO_URL_THUMBNAIL="https://github.com/unlimitedbacon/stl-thumb.git"
TMP_DIR_THUMBNAIL="/tmp/stl-thumb"

# ###########################################################
# STL packages
# ###########################################################
if command -v stl-thumb &> /dev/null && command -v fstl &> /dev/null; then
	echo "=> STL packages are already installed."
	exit 0
fi

# ###########################################################
# Dependencies packages
# ###########################################################
install_official \
	"base-devel rust cmake git" \
	"Installing dependencies..."

# ###########################################################
# Clone repository for Viewer
# ###########################################################
echo "=> Removing old $TMP_DIR_VIEWER..."
sudo rm -rf "$TMP_DIR_VIEWER" || true

echo "=> Cloning fstl repository..."
git clone "$REPO_URL_VIEWER" "$TMP_DIR_VIEWER" &> /dev/null || true

# ###########################################################
# Build and install fstl
# ###########################################################
echo "=> Building and installing fstl..."
(
	cd "$TMP_DIR_VIEWER"
	mkdir -p build
	cd build
	cmake ..
	make -j8
	sudo cp fstl /usr/bin
) &> /dev/null || true

# ###########################################################
# Register desktop entry for fstl
# ###########################################################
echo "=> Registering fstl as the default STL viewer..."
sudo bash -c 'cat << EOF > /usr/share/applications/fstl.desktop
[Desktop Entry]
Name=fstl
Exec=fstl %U
Type=Application
MimeType=model/stl;model/x.stl-binary;model/x.stl-ascii;application/sla;
Icon=model
EOF'
sudo update-desktop-database /usr/share/applications

# ###########################################################
# Register fstl as default STL viewer
# ###########################################################
if [ -f "$HOME/.config/mimeapps.list" ]; then
	if ! grep -q "\[Default Applications\]" "$HOME/.config/mimeapps.list"; then
		echo "[Default Applications]" >> "$HOME/.config/mimeapps.list"
	fi
	if ! grep -q "model/stl=fstl.desktop" "$HOME/.config/mimeapps.list"; then
		echo "" >> "$HOME/.config/mimeapps.list"
		echo "model/stl=fstl.desktop" >> "$HOME/.config/mimeapps.list"
		echo "model/x.stl-binary=fstl.desktop" >> "$HOME/.config/mimeapps.list"
		echo "model/x.stl-ascii=fstl.desktop" >> "$HOME/.config/mimeapps.list"
	fi
else
	cat << EOF > "$HOME/.config/mimeapps.list"
[Default Applications]
model/stl=fstl.desktop
model/x.stl-binary=fstl.desktop
model/x.stl-ascii=fstl.desktop=fstl.desktop
EOF
fi


# ###########################################################
# Clone repository for Thumbnailer
# ###########################################################
echo "=> Removing old $TMP_DIR_THUMBNAIL..."
sudo rm -rf "$TMP_DIR_THUMBNAIL" || true

echo "=> Cloning stl-thumb repository..."
git clone "$REPO_URL_THUMBNAIL" "$TMP_DIR_THUMBNAIL" &> /dev/null || true

# ###########################################################
# Build and install stl-thumb
# ###########################################################
echo "=> Building and installing stl-thumb..."
(
	cd "$TMP_DIR_THUMBNAIL"
	cargo build --release
	sudo cp target/release/stl-thumb /usr/bin
) &> /dev/null || true

# ###########################################################
# Register Thumbnailer
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
