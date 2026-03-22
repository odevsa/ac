#!/bin/bash
set -euo pipefail
sudo -v

RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
NOCOLOR=`tput sgr0`

print_center(){
    local x
    local y
    text="$*"
    x=$(( ($(tput cols) - ${#text}) / 2))
    echo -ne "\E[6n";read -sdR y; y=$(echo -ne "${y#*[}" | cut -d';' -f1)
    echo -ne "\033[${y};${x}f$*"
    echo
}

print_topic(){
    LINE_CHAR=${3:-―}
    printf ${2:-$NOCOLOR}
    eval printf %.0s$LINE_CHAR '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
    print_center $1
    eval printf %.0s$LINE_CHAR '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
    printf $NOCOLOR
}

print_header(){
    print_topic "$1" ${2:-$NOCOLOR} █
}

TMP_DIR=/tmp/ac

NO_AMDGPU=false
NO_NVIDIA=false
NO_GPU=false
NO_APPS=false
ONLY_CORE=false

for arg in "$@"; do
    case $arg in
        --no-amdgpu)
            NO_AMDGPU=true
            ;;
        --no-nvidia)
            NO_NVIDIA=true
            ;;
        --no-gpu)
            NO_GPU=true
            ;;
        --no-apps)
            NO_APPS=true
            ;;
        --only-core)
            ONLY_CORE=true
            ;;
        *)
            echo "Unknown option: $arg"
            ;;
    esac
done

print_header "Let me do the hard work and go get some ☕" $BLUE

print_topic "Dependencies"

packages=("git")

for package in "${packages[@]}"; do
    if ! pacman -Qi "$package" &> /dev/null; then
        echo "=> Installing $package..."
        sudo pacman -S --noconfirm --needed "$package" &> /dev/null
    else
        echo "=> $package already installed."
    fi
done

echo "=> Cloning into $TMP_DIR..."
sudo rm -rf "$TMP_DIR"
git clone https://github.com/odevsa/ac.git "$TMP_DIR" &> /dev/null

print_topic "Pacman"
chmod +x "$TMP_DIR/tasks/pacman.sh"
bash "$TMP_DIR/tasks/pacman.sh"

print_topic "Flatpak"
chmod +x "$TMP_DIR/tasks/flatpak.sh"
bash "$TMP_DIR/tasks/flatpak.sh"

print_topic "AUR"
chmod +x "$TMP_DIR/tasks/aur.sh"
bash "$TMP_DIR/tasks/aur.sh"

print_topic "Dotfiles"
chmod +x "$TMP_DIR/tasks/dotfiles.sh"
bash "$TMP_DIR/tasks/dotfiles.sh"

print_topic "Core"
chmod +x "$TMP_DIR/tasks/core.sh"
bash "$TMP_DIR/tasks/core.sh"

print_topic "ZSH and Oh-My-Posh"
chmod +x "$TMP_DIR/tasks/zsh.sh"
bash "$TMP_DIR/tasks/zsh.sh"

if [ "$NO_AMDGPU" = false ] && [ "$NO_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
    print_topic "GPU Drivers (AMD)"
    chmod +x "$TMP_DIR/tasks/amdgpu.sh"
    bash "$TMP_DIR/tasks/amdgpu.sh"
fi

if [ "$NO_NVIDIA" = false ] && [ "$NO_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
    print_topic "GPU Drivers (NVIDIA)"
    chmod +x "$TMP_DIR/tasks/nvidia.sh"
    bash "$TMP_DIR/tasks/nvidia.sh"
fi

print_topic "Fonts"
chmod +x "$TMP_DIR/tasks/fonts.sh"
bash "$TMP_DIR/tasks/fonts.sh"

if [ "$NO_APPS" = false ] && [ "$ONLY_CORE" = false ]; then
    print_topic "Applications"
    chmod +x "$TMP_DIR/tasks/applications.sh"
    bash "$TMP_DIR/tasks/applications.sh"
fi

print_topic "Neovim"
chmod +x "$TMP_DIR/tasks/neovim.sh"
bash "$TMP_DIR/tasks/neovim.sh"

print_topic "Docker"
chmod +x "$TMP_DIR/tasks/docker.sh"
bash "$TMP_DIR/tasks/docker.sh"

print_topic "Browser"
chmod +x "$TMP_DIR/tasks/browser.sh"
bash "$TMP_DIR/tasks/browser.sh" "google-chrome"

print_topic "Desktop Environment (Cosmic)"
chmod +x "$TMP_DIR/tasks/cosmic.sh"
bash "$TMP_DIR/tasks/cosmic.sh"

print_header "Finished! 🍺" $GREEN
echo "Reboot now? (Y/n)" && read CONFIRM_REBOOT
if [ "$CONFIRM_REBOOT" == "y" ] || [ "$CONFIRM_REBOOT" == "Y" ] || [ -z "$CONFIRM_REBOOT" ]; then
	echo "=> Rebooting..."
    sudo reboot
fi