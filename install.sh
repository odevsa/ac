#!/bin/bash
set -euo pipefail
source "helpers.sh"
sudo -v

# ###########################################################
# Flags
# ###########################################################
TMP_DIR="."
SKIP_AMDGPU=false
SKIP_NVIDIA=false
SKIP_GPU=false
SKIP_APPS=false
SKIP_NEOVIM=false
SKIP_DOCKER=false
SKIP_AUR_HELPER=false
SKIP_PREFERENCES=false
ONLY_CORE=false

for arg in "$@"; do
  case $arg in
    --skip-aur-helper)
      SKIP_AUR_HELPER=true
      ;;
    --skip-amdgpu)
      SKIP_AMDGPU=true
      ;;
    --skip-nvidia)
      SKIP_NVIDIA=true
      ;;
    --skip-gpu)
      SKIP_GPU=true
      ;;
    --skip-apps)
      SKIP_APPS=true
      ;;
    --skip-neovim)
      SKIP_NEOVIM=true
      ;;
    --skip-docker)
      SKIP_DOCKER=true
      ;;
    --only-core)
      ONLY_CORE=true
      ;;
    --skip-preferences)
      SKIP_PREFERENCES=true
      ;;
    *)
      echo "Unknown option: $arg"
      ;;
  esac
done

# ###########################################################
# Running tasks
# ###########################################################
print_header "Let me do the hard work and go get some coffee" $BLUE

print_topic "Pacman"
chmod +x "$TMP_DIR/tasks/pacman.sh"
bash "$TMP_DIR/tasks/pacman.sh"

print_topic "Flatpak"
chmod +x "$TMP_DIR/tasks/flatpak.sh"
bash "$TMP_DIR/tasks/flatpak.sh"

if [ "$SKIP_AUR_HELPER" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "AUR"
  chmod +x "$TMP_DIR/tasks/aur.sh"
  bash "$TMP_DIR/tasks/aur.sh"
fi

print_topic "Dotfiles"
chmod +x "$TMP_DIR/tasks/dotfiles.sh"
bash "$TMP_DIR/tasks/dotfiles.sh"

print_topic "Core"
chmod +x "$TMP_DIR/tasks/core.sh"
bash "$TMP_DIR/tasks/core.sh"

print_topic "ZSH and Oh-My-Posh"
chmod +x "$TMP_DIR/tasks/zsh.sh"
bash "$TMP_DIR/tasks/zsh.sh"

if [ "$SKIP_AMDGPU" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "GPU Drivers (AMD)"
  chmod +x "$TMP_DIR/tasks/amdgpu.sh"
  bash "$TMP_DIR/tasks/amdgpu.sh"
fi

if [ "$SKIP_NVIDIA" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "GPU Drivers (NVIDIA)"
  chmod +x "$TMP_DIR/tasks/nvidia.sh"
  bash "$TMP_DIR/tasks/nvidia.sh"
fi

print_topic "Fonts"
chmod +x "$TMP_DIR/tasks/fonts.sh"
bash "$TMP_DIR/tasks/fonts.sh"

if [ "$SKIP_APPS" = false ] && [ "$ONLY_CORE" = false ]; then
  FLAGS=$([[ $SKIP_AUR_HELPER = true ]] && echo "--skip-aur-helper" || echo "")
  print_topic "Applications"
  chmod +x "$TMP_DIR/tasks/applications.sh"
  bash "$TMP_DIR/tasks/applications.sh" ${FLAGS}
fi

if [ "$SKIP_NEOVIM" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "Neovim"
  chmod +x "$TMP_DIR/tasks/neovim.sh"
  bash "$TMP_DIR/tasks/neovim.sh"
fi

if [ "$SKIP_DOCKER" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "Docker"
  chmod +x "$TMP_DIR/tasks/docker.sh"
  bash "$TMP_DIR/tasks/docker.sh"
fi

BROWSER="google-chrome"
FLAGS="$BROWSER $([[ $SKIP_AUR_HELPER = true ]] && echo "--skip-aur-helper" || echo "")"
print_topic "Browser"
chmod +x "$TMP_DIR/tasks/browser.sh"
bash "$TMP_DIR/tasks/browser.sh" ${FLAGS}

if [ "$SKIP_PREFERENCES" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "Preferences"
  chmod +x "$TMP_DIR/tasks/preferences.sh"
  bash "$TMP_DIR/tasks/preferences.sh"

  chmod +x "$TMP_DIR/tasks/stl.sh"
  bash "$TMP_DIR/tasks/stl.sh"
fi


print_topic "Desktop Environment (Cosmic)"
chmod +x "$TMP_DIR/tasks/cosmic.sh"
bash "$TMP_DIR/tasks/cosmic.sh"

# ###########################################################
# Finishing up
# ###########################################################
print_header "Finished!" $GREEN
echo "Reboot now? (Y/n)" && read CONFIRM_REBOOT
if [ "$CONFIRM_REBOOT" == "y" ] || [ "$CONFIRM_REBOOT" == "Y" ] || [ -z "$CONFIRM_REBOOT" ]; then
	echo "=> Rebooting..."
  sudo reboot
fi
