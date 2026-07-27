#!/bin/bash
set -euo pipefail
source "helpers.sh"
source "logo.sh"
reset

# ###########################################################
# Logo
# ###########################################################
print_logo default 1

# ###########################################################
# Setup
# ###########################################################
TMP_DIR="."
RUN_ONLY_CORE=false
RUN_DOTFILES=true
RUN_GPU=all
RUN_AMDGPU=true
RUN_NVIDIA=true
RUN_APPS=true
RUN_DOCKER=true
RUN_PREFERENCES=true
RUN_DEFAULT=false
CHOSEN_SHELL="zsh"

for arg in "$@"; do
  case $arg in
    --default)
      RUN_DEFAULT=true
      ;;
    *)
      log "Unknown option: $arg" error
      exit 1
      ;;
  esac
done

if [ "$RUN_DEFAULT" = false ] && [ "$#" -eq 0 ]; then
  print_header "What tasks do you want to run?" warning

  print_start
    QUESTION="Run only the core (only core)? (y/N)"
    ANSWER=$(ask "$QUESTION" warning)
    asked_rewrite "$QUESTION" "$ANSWER"
    if [[ $ANSWER == [yY] ]]; then
      RUN_ONLY_CORE=true
    fi

    QUESTION="Which shell do you want to use? (ZSH/fish/bash)"
    ANSWER=$(ask "$QUESTION" warning)
    asked_rewrite "$QUESTION" "$ANSWER"
    ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
    if [[ $ANSWER == "fish" ]] || [[ $ANSWER == "bash" ]] || [[ $ANSWER == "zsh" ]]; then
      CHOSEN_SHELL="$ANSWER"
    fi

    if [ "$RUN_ONLY_CORE" = false ]; then
      QUESTION="Run dotfiles installation? (Y/n)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [nN] ]]; then
        RUN_DOTFILES=false
      fi

      QUESTION="Run GPU drivers? (ALL/amdgpu/nvidia/none)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
      if [[ $ANSWER == "all" ]] || [[ $ANSWER == "amdgpu" ]] || [[ $ANSWER == "nvidia" ]] || [[ $ANSWER == "none" ]]; then
        RUN_GPU="$ANSWER"
      fi

      QUESTION="Run applications installation? (Y/n)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [nN] ]]; then
        RUN_APPS=false
      fi

      QUESTION="Run Docker installation? (Y/n)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [nN] ]]; then
        RUN_DOCKER=false
      fi

      QUESTION="Run preferences? (Y/n)"
      ANSWER=$(ask "$QUESTION" warning)
      asked_rewrite "$QUESTION" "$ANSWER"
      if [[ $ANSWER == [nN] ]]; then
        RUN_PREFERENCES=false
      fi
    fi
  print_end
fi

# ###########################################################
# Summary
# ###########################################################
print_header "Let me do the hard work and go get some coffee" info
print_start
  flags=""
  if [ "$RUN_DEFAULT" = true ]; then flags="$flags--default "; fi
  if [ "${#flags}" -eq 0 ]; then flags="No flags were passed"; fi
  log "Flags: $flags" warning

  log "Task: Pacman" success
  log "Task: Flatpak" success
  log "Task: Core" success
  log "Task: Shell and Oh-My-Posh ($CHOSEN_SHELL)" success
  log "Task: Fonts" success
  log "Task: Icons" success
  log "Task: Browser" success

  if [ "$RUN_DOTFILES" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
    log "Task: Dotfiles" success
  else
    log "Task: Dotfiles" muted
  fi
  if { [ "$RUN_GPU" = "all" ] || [ "$RUN_GPU" = "amdgpu" ]; } && [ "$RUN_ONLY_CORE" = false ]; then
    log "Task: GPU Drivers (AMD)" success
  else
    log "Task: GPU Drivers (AMD)" muted
  fi

  if { [ "$RUN_GPU" = "all" ] || [ "$RUN_GPU" = "nvidia" ]; } && [ "$RUN_ONLY_CORE" = false ]; then
    log "Task: GPU Drivers (NVIDIA)" success
  else
    log "Task: GPU Drivers (NVIDIA)" muted
  fi

  if [ "$RUN_APPS" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
    log "Task: Applications" success
  else
    log "Task: Applications" muted
  fi

  if [ "$RUN_DOCKER" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
    log "Task: Docker" success
  else
    log "Task: Docker" muted
  fi

  if [ "$RUN_PREFERENCES" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
    log "Task: Preferences" success
  else
    log "Task: Preferences" muted
  fi

  log "Task: Desktop Environment (Cosmic)" success
print_end

# ###########################################################
# Running tasks
# ###########################################################
sudo -v

# Core tasks
run_task "Pacman" "$TMP_DIR/tasks/pacman.sh"

run_task "Core" "$TMP_DIR/tasks/core.sh"

run_task "Flatpak" "$TMP_DIR/tasks/flatpak.sh"

run_task "Shell and Oh-My-Posh" "$TMP_DIR/tasks/shell.sh" "$CHOSEN_SHELL"

run_task "Fonts" "$TMP_DIR/tasks/fonts.sh"

run_task "Icons" "$TMP_DIR/tasks/icons.sh"

run_task "Browser" "$TMP_DIR/tasks/browser.sh"

# Optional tasks
if [ "$RUN_DOTFILES" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
  run_task "Dotfiles" "$TMP_DIR/tasks/dotfiles.sh"
fi

if { [ "$RUN_GPU" = "all" ] || [ "$RUN_GPU" = "amdgpu" ]; } && [ "$RUN_ONLY_CORE" = false ]; then
  run_task "GPU Drivers (AMD)" "$TMP_DIR/tasks/amdgpu.sh"
fi

if { [ "$RUN_GPU" = "all" ] || [ "$RUN_GPU" = "nvidia" ]; } && [ "$RUN_ONLY_CORE" = false ]; then
  run_task "GPU Drivers (NVIDIA)" "$TMP_DIR/tasks/nvidia.sh"
fi

if [ "$RUN_APPS" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
  run_task "Applications" "$TMP_DIR/tasks/applications.sh"
fi

if [ "$RUN_DOCKER" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
  run_task "Docker" "$TMP_DIR/tasks/docker.sh"
fi

if [ "$RUN_PREFERENCES" = true ] && [ "$RUN_ONLY_CORE" = false ]; then
  run_task "Preferences" "$TMP_DIR/tasks/preferences.sh"
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
