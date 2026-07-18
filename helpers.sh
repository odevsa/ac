#!/usr/bin/env bash

NOCOLOR=`tput sgr0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
GRAY=`tput setaf 8`
TOTAL_COLUMNS=$(tput cols 2>/dev/null || echo 80)
TOTAL_CONTENT_COLUMNS=$((TOTAL_COLUMNS - 4))

get_color(){
    case "$1" in
        warning) color="$YELLOW" ;;
        error) color="$RED" ;;
        info) color="$BLUE" ;;
        success) color="$GREEN" ;;
        muted) color="$GRAY" ;;
        *) color="$NOCOLOR" ;;
    esac
    printf "%s" "$color"
}

get_icon(){
    case "$1" in
        warning) icon="⚠" ;;
        error) icon="⨯" ;;
        info) icon="🛈" ;;
        success) icon="✔" ;;
        muted) icon="" ;;
        *) icon="" ;;
    esac
    printf "%s" "$icon"
}

print_repeat(){
    local char="$1"
    local count="$2"
    for ((i=0;i<count;i++)); do printf '%s' "$char"; done
}

print_centered(){
    local text cols padding
    text="$1"
    start=${2:-''}
    end=${3:-''}
    padding=$(( (TOTAL_COLUMNS - ${#text} - ${#start} - ${#end}) / 2 ))
    padding_increment=$(( (TOTAL_COLUMNS - ${#text} - ${#start} - ${#end} - ${padding} - ${padding}) ))
    if [ "$padding" -lt 0 ]; then padding=0; fi
    printf "$start"
    print_repeat " " "$padding"
    printf "$text"
    print_repeat " " "$((padding + padding_increment))"
    printf "$end\n"
}

print_topic(){
    local line_char cols i
    color=$(get_color "${2:-}")
    line_char=${3:-'░'}
    line_char_top=${4:-"$line_char"}
    printf "$color"
    print_repeat "$line_char_top" "$TOTAL_COLUMNS"
    printf '\n'
    print_centered "$1" "$line_char$line_char" "$line_char$line_char"
    print_repeat "$line_char" "$TOTAL_COLUMNS"
    printf "\n$NOCOLOR"
}

print_header(){
    message="$1"
    icon=$(get_icon "${2:-info}")
    if [ -n "$icon" ]; then
        message="$icon $message $icon"
    fi
    print_topic "$message" "${2:-}" "█"
}

print_start(){
    color=$(get_color "${1:-muted}")
    printf "%s" "$color"
    printf "░░"
    print_repeat " " "$TOTAL_CONTENT_COLUMNS"
    printf "░░\n"
}

print_content(){
    text="$1"
    plain_text=$(echo -e "$text" | sed 's/\x1B\[[0-9;]*[JKmsu]//g')
    padding_increment=$((TOTAL_CONTENT_COLUMNS - ${#plain_text}))
    printf "$GRAY"
    printf "░░"
    printf "$NOCOLOR"
    printf "$text"
    print_repeat " " "$padding_increment"
    printf "$GRAY"
    printf "░░\n"
    printf "$NOCOLOR"
}

print_end(){
    local line_char cols i
    color=$(get_color "${1:-muted}")
    printf "%s" "$color"
    printf "░░"
    print_repeat " " "$TOTAL_CONTENT_COLUMNS"
    printf "░░\n"
    for ((i=0;i<TOTAL_COLUMNS;i++)); do printf '%s' "░"; done; printf '\n'
    printf "$NOCOLOR\n"
}

log(){
    color=$(get_color "${2:-info}")
    print_content "   $color➤  $1"
}

log_sub(){
    color=$(get_color "${2:-muted}")
    icon=$(get_icon "${2:-muted}")
    prefix="      $GRAY├─$color"
    if [ -n "$icon" ]; then
        prefix="$prefix $icon"
    fi
    print_content "$prefix $1"
}

ask(){
    color=$(get_color "${2:-}")
    read -p "$GRAY░░   $color➤  $1: $NOCOLOR" answer
    printf "$answer"
}

install_official() {
    local package="$1"
    local message="${2:-}"
    local is_checking_dependencies="${3:-false}"

    if [ -n "$message" ]; then
        log "$message"
    else
        log "$package..."
    fi

    packages_to_install=()
    packages_installed=()
    for pkg in $package; do
        if pacman -Qi "$pkg" &> /dev/null || pacman -Qg "$pkg" &> /dev/null; then
            packages_installed+=("$pkg")
        else
            packages_to_install+=("$pkg")
        fi
    done

    if [ ${#packages_installed[@]} -gt 0 ] && [ "$is_checking_dependencies" = false ]; then
        log_sub "Already installed: ${packages_installed[*]}" muted
    fi

    sudo pacman -S --noconfirm --needed \
        $package \
        &> /dev/null || true

    if [ ${#packages_to_install[@]} -gt 0 ]; then
        log_sub "Installed: ${packages_to_install[*]}" success
    else
        if [ "$is_checking_dependencies" = true ]; then
            log_sub "All dependencies are ok." success
        fi
    fi
}

enable_service(){
  service=$1
  log "Enabling '$service' service..."
  if $(systemctl is-enabled --quiet "$service"); then
    log_sub "Service '$service' is already enabled." warning
  else
    sudo systemctl enable "$service" &> /dev/null || true
    log_sub "Service '$service' has been enabled." success
  fi
}

enable_start_service(){
  service=$1
  log "Enabling and starting '$service' service..."
  if $(systemctl is-enabled --quiet "$service"); then
    log_sub "Service '$service' is already enabled and running." warning
  else
    sudo systemctl enable --now "$service" &> /dev/null || true
    log_sub "Service '$service' has been enabled and running." success
  fi
}

run_task(){
  name="$1"
  script="$2"
  print_topic "$name"
  print_start
  bash "$script"
  print_end
}

