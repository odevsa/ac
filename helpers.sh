#!/usr/bin/env bash

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

install_official() {
    local package="$1"
    local message="${2:-}"

    if [ -n "$message" ]; then
        echo "=> $message"
    else
        echo "=> Installing $package..."
    fi
    sudo pacman -S --noconfirm --needed \
        $package #\
        #&> /dev/null || true
}

install_aur() {
    local package="$1"
    local message="${2:-}"
    
    if [ -n "$message" ]; then
        echo "=> $message"
    else
        echo "=> Installing AUR $package..."
    fi
    yay -S --noconfirm --needed \
        $package #\
        #&> /dev/null || true
}

install_official_or_aur() {
    local is_official="$1"
    local official="${2:-}"
    local aur="${3:-}"

    if [ "$is_official" = true ]; then
        install_official "$official"
    else
        install_aur "$aur"
    fi
}
