#!/bin/bash
set -euo pipefail
source "helpers.sh"
source "logo.sh"

# ###########################################################
# Logo
# ###########################################################
print_logo default 1

# ###########################################################
# Flags
# ###########################################################
TMP_DIR="."
ONLY_CORE=false
SKIP_DOTFILES=false
SKIP_GPU=false
SKIP_AMDGPU=false
SKIP_NVIDIA=false
SKIP_APPS=false
SKIP_DOCKER=false
SKIP_PREFERENCES=false
DEFAULT=false

for arg in "$@"; do
  case $arg in
    --only-core)
      ONLY_CORE=true
      ;;
    --skip-dotfiles)
      SKIP_DOTFILES=true
      ;;
    --skip-gpu)
      SKIP_GPU=true
      ;;
    --skip-amdgpu)
      SKIP_AMDGPU=true
      ;;
    --skip-nvidia)
      SKIP_NVIDIA=true
      ;;
    --skip-apps)
      SKIP_APPS=true
      ;;
    --skip-docker)
      SKIP_DOCKER=true
      ;;
    --skip-preferences)
      SKIP_PREFERENCES=true
      ;;
    --default)
      DEFAULT=true
      ;;
    *)
      log "Unknown option: $arg" error
      exit 1
      ;;
  esac
done

if [ "$DEFAULT" = false ] && [ "$#" -eq 0 ]; then
  print_header "Do you want to skip any tasks?" warning

  print_start
    QUESTION="Run only the core (only core)? (y/N)"
    ANSWER=$(ask "$QUESTION" warning)
    asked_rewrite "$QUESTION" "$ANSWER"
    if [[ $ANSWER == [yY] ]]; then
      ONLY_CORE=true
    fi

    if [ "$ONLY_CORE" = false ]; then
      QUESTION="Skip dotfiles installation? (y/N)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [yY] ]]; then
        SKIP_DOTFILES=true
      fi


      QUESTION="Skip all GPU drivers (AMD + NVIDIA)? (y/N)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [yY] ]]; then
        SKIP_GPU=true
        SKIP_AMDGPU=true
        SKIP_NVIDIA=true
      fi

      if [ "$SKIP_GPU" = false ]; then
        QUESTION="Skip only AMDGPU drivers? (y/N)"
        ANSWER=$(ask "$QUESTION" warning)
        asked_rewrite "$QUESTION" "$ANSWER"
        if [[ $ANSWER == [yY] ]]; then
          SKIP_AMDGPU=true
        fi

        QUESTION="Skip only NVIDIA drivers? (y/N)"
        ANSWER=$(ask "$QUESTION" warning)
        asked_rewrite "$QUESTION" "$ANSWER"
        if [[ $ANSWER == [yY] ]]; then
          SKIP_NVIDIA=true
        fi
      fi

      QUESTION="Skip applications installation? (y/N)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [yY] ]]; then
        SKIP_APPS=true
      fi

      QUESTION="Skip Docker installation? (y/N)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [yY] ]]; then
        SKIP_DOCKER=true
      fi

      QUESTION="Skip preferences? (y/N)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [yY] ]]; then
        SKIP_PREFERENCES=true
      fi
    fi
  print_end
fi

# ###########################################################
# Running tasks
# ###########################################################
sudo -v

print_header "Let me do the hard work and go get some coffee" info
print_start
  flags=""
  if [ "$ONLY_CORE" = true ]; then flags="$flags--only-core "; fi
  if [ "$SKIP_DOTFILES" = true ]; then flags="$flags--skip-dotfiles "; fi
  if [ "$SKIP_GPU" = true ]; then flags="$flags--skip-gpu "; fi
  if [ "$SKIP_AMDGPU" = true ]; then flags="$flags--skip-amdgpu "; fi
  if [ "$SKIP_NVIDIA" = true ]; then flags="$flags--skip-nvidia "; fi
  if [ "$SKIP_APPS" = true ]; then flags="$flags--skip-apps "; fi
  if [ "$SKIP_DOCKER" = true ]; then flags="$flags--skip-docker "; fi
  if [ "$SKIP_PREFERENCES" = true ]; then flags="$flags--skip-preferences "; fi
  if [ "$DEFAULT" = true ]; then flags="$flags--default "; fi
  if [ "${#flags}" -eq 0 ]; then flags="No flags were passed"; fi
  log "Flags: $flags" warning

  log "Task: Pacman" success
  log "Task: Flatpak" success
  log "Task: Core" success
  log "Task: Shell and Oh-My-Posh" success
  log "Task: Fonts" success
  log "Task: Icons" success
  log "Task: Browser" success

  if [ "$SKIP_DOTFILES" = false ] && [ "$ONLY_CORE" = false ]; then
    log "Task: Dotfiles" success
  else
    log "Task: Dotfiles" muted
  fi
  if [ "$SKIP_AMDGPU" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
    log "Task: GPU Drivers (AMD)" success
  else
    log "Task: GPU Drivers (AMD)" muted
  fi

  if [ "$SKIP_NVIDIA" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
    log "Task: GPU Drivers (NVIDIA)" success
  else
    log "Task: GPU Drivers (NVIDIA)" muted
  fi

  if [ "$SKIP_APPS" = false ] && [ "$ONLY_CORE" = false ]; then
    log "Task: Applications" success
  else
    log "Task: Applications" muted
  fi

  if [ "$SKIP_DOCKER" = false ] && [ "$ONLY_CORE" = false ]; then
    log "Task: Docker" success
  else
    log "Task: Docker" muted
  fi

  if [ "$SKIP_PREFERENCES" = false ] && [ "$ONLY_CORE" = false ]; then
    log "Task: Preferences" success
  else
    log "Task: Preferences" muted
  fi

  log "Task: Desktop Environment (Cosmic)" success
print_end

# Core tasks
run_task "Pacman" "$TMP_DIR/tasks/pacman.sh"

run_task "Core" "$TMP_DIR/tasks/core.sh"

run_task "Flatpak" "$TMP_DIR/tasks/flatpak.sh"

run_task "Shell and Oh-My-Posh" "$TMP_DIR/tasks/shell.sh"

run_task "Fonts" "$TMP_DIR/tasks/fonts.sh"

run_task "Icons" "$TMP_DIR/tasks/icons.sh"

run_task "Browser" "$TMP_DIR/tasks/browser.sh"

# Optional tasks
if [ "$SKIP_DOTFILES" = false ] && [ "$ONLY_CORE" = false ]; then
  run_task "Dotfiles" "$TMP_DIR/tasks/dotfiles.sh"
fi

if [ "$SKIP_AMDGPU" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
  run_task "GPU Drivers (AMD)" "$TMP_DIR/tasks/amdgpu.sh"
fi

if [ "$SKIP_NVIDIA" = false ] && [ "$SKIP_GPU" = false ] && [ "$ONLY_CORE" = false ]; then
  run_task "GPU Drivers (NVIDIA)" "$TMP_DIR/tasks/nvidia.sh"
fi

if [ "$SKIP_APPS" = false ] && [ "$ONLY_CORE" = false ]; then
  run_task "Applications" "$TMP_DIR/tasks/applications.sh"
fi

if [ "$SKIP_DOCKER" = false ] && [ "$ONLY_CORE" = false ]; then
  run_task "Docker" "$TMP_DIR/tasks/docker.sh"
fi

if [ "$SKIP_PREFERENCES" = false ] && [ "$ONLY_CORE" = false ]; then
  run_task "Preferences" "$TMP_DIR/tasks/preferences.sh"
  # run_task "STL" "$TMP_DIR/tasks/stl.sh"
fi

# Desktop Environment
run_task "Desktop Environment (Cosmic)" "$TMP_DIR/tasks/cosmic.sh"

# ###########################################################
# Finishing up
# ###########################################################
print_header "Finished!" success
print_start
  QUESTION="Reboot now? (Y/n)"
  ANSWER=$(ask "$QUESTION" success)
  asked_rewrite "$QUESTION" "$ANSWER"
  if [ "$ANSWER" == "y" ] || [ "$ANSWER" == "Y" ] || [ -z "$ANSWER" ]; then
    log_sub "Rebooting..." info
    sudo reboot
  fi
print_end
