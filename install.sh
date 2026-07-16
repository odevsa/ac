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
SKIP_DOCKER=false
SKIP_PREFERENCES=false
ONLY_CORE=false

for arg in "$@"; do
  case $arg in
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

# If no flags were provided, ask the user which flags they want to use
if [ "$#" -eq 0 ]; then
  print_header "No flag provided" $YELLOW

  print_topic "Asking which tasks to skip" $YELLOW

  read -p "Run only the core (only core)? (y/N) " ANSWER
  if [[ $ANSWER == [yY] ]]; then
    ONLY_CORE=true
  fi

  if [ "$ONLY_CORE" = false ]; then
    read -p "Skip all GPU drivers (AMD + NVIDIA)? (y/N) " ANSWER
    if [[ $ANSWER == [yY] ]]; then
      SKIP_GPU=true
      SKIP_AMDGPU=true
      SKIP_NVIDIA=true
    fi

    if [ "$SKIP_GPU" = false ]; then
      read -p "Skip only AMDGPU drivers? (y/N) " ANSWER
      if [[ $ANSWER == [yY] ]]; then
        SKIP_AMDGPU=true
      fi

      read -p "Skip only NVIDIA drivers? (y/N) " ANSWER
      if [[ $ANSWER == [yY] ]]; then
        SKIP_NVIDIA=true
      fi
    fi

    read -p "Skip applications installation? (y/N) " ANSWER
    if [[ $ANSWER == [yY] ]]; then
      SKIP_APPS=true
    fi

    read -p "Skip Docker? (y/N) " ANSWER
    if [[ $ANSWER == [yY] ]]; then
      SKIP_DOCKER=true
    fi

    read -p "Skip system preferences? (y/N) " ANSWER
    if [[ $ANSWER == [yY] ]]; then
      SKIP_PREFERENCES=true
    fi
  fi
fi

# ###########################################################
# Running tasks
# ###########################################################
print_header "Let me do the hard work and go get some coffee" $BLUE

print_topic "Pacman"
bash "$TMP_DIR/tasks/pacman.sh"

print_topic "Flatpak"
bash "$TMP_DIR/tasks/flatpak.sh"

print_topic "Dotfiles"
bash "$TMP_DIR/tasks/dotfiles.sh"

print_topic "Core"
bash "$TMP_DIR/tasks/core.sh"

print_topic "Shell and Oh-My-Posh"
bash "$TMP_DIR/tasks/shell.sh"

if [ "$SKIP_AMDGPU" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "GPU Drivers (AMD)"
  bash "$TMP_DIR/tasks/amdgpu.sh"
fi

if [ "$SKIP_NVIDIA" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "GPU Drivers (NVIDIA)"
  bash "$TMP_DIR/tasks/nvidia.sh"
fi

print_topic "Fonts"
bash "$TMP_DIR/tasks/fonts.sh"

print_topic "Icons"
bash "$TMP_DIR/tasks/icons.sh"

if [ "$SKIP_APPS" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "Applications"
  bash "$TMP_DIR/tasks/applications.sh"
fi

if [ "$SKIP_DOCKER" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "Docker"
  bash "$TMP_DIR/tasks/docker.sh"
fi

print_topic "Browser"
bash "$TMP_DIR/tasks/browser.sh"

if [ "$SKIP_PREFERENCES" = false ] && [ "$ONLY_CORE" = false ]; then
  print_topic "Preferences"
  bash "$TMP_DIR/tasks/preferences.sh"
  bash "$TMP_DIR/tasks/stl.sh"
fi


print_topic "Desktop Environment (Cosmic)"
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
