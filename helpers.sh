#!/usr/bin/env bash

RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
NOCOLOR=`tput sgr0`

print_center(){
    local text cols padding
    text="$*"
    cols=$(tput cols 2>/dev/null || echo 80)
    padding=$(( (cols - ${#text}) / 2 ))
    if [ "$padding" -lt 0 ]; then padding=0; fi
    printf '%*s%s\n' "$padding" "" "$text"
}

print_topic(){
    local line_char cols i
    line_char=${3:-'-'}
    cols=$(tput cols 2>/dev/null || echo 80)
    printf "%s" "${2:-$NOCOLOR}"
    for ((i=0;i<cols;i++)); do printf '%s' "${line_char}"; done; printf '\n'
    print_center "$1"
    for ((i=0;i<cols;i++)); do printf '%s' "${line_char}"; done; printf '\n'
    printf "%s" "$NOCOLOR"
}

print_header(){
    print_topic "$1" ${2:-$NOCOLOR} █
}
    
install_official() {
    local package="$1"
    local message="${2:-}"

    if [ -n "$message" ]; then
        echo "=> $message"
    else
        echo "=> Installing $package..."
    fi
    sudo pacman -S --noconfirm --needed \
        $package \
        &> /dev/null || true
}
