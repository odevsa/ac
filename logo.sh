#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

COLOR="\e[38;2;23;147;209m"

icon_logo() {
  local icon=(
    "                  ▄"
    "                 ▟█▙"
    "                ▟███▙"
    "               ▟█████▙"
    "              ▟███████▙"
    "             ▂▔▀▜██████▙"
    "            ▟██▅▂▝▜█████▙"
    "           ▟█████████████▙"
    "          ▟███████████████▙"
    "         ▟█████████████████▙"
    "        ▟███████████████████▙"
    "       ▟█████████▛▀▀▜████████▙"
    "      ▟████████▛      ▜███████▙"
    "     ▟█████████        ████████▙"
    "    ▟██████████        █████▆▅▄▃▂"
    "   ▟██████████▛        ▜█████████▙"
    "  ▟██████▀▀▀              ▀▀██████▙"
    " ▟███▀▘                       ▝▀███▙"
    "▟▛▀                               ▀▜▙"
  )
  
  local size=0
  for line in "${icon[@]}"; do
    if [ "${#line}" -gt "$size" ]; then
      size="${#line}"
    fi
  done

  local padding=$(( (TOTAL_COLUMNS - size) / 2 ))

  printf "$COLOR"
  for line in "${icon[@]}"; do
    print_repeat " " "$padding"
    echo "$line"
  done
}

logo_default() {
  local logo=(
    "   █████████                       ███                           █████████                                    ███          "
    "  ███░░░░░███                     ░███              ███         ███░░░░░░██                                  ░░░           "
    " ░███    ░███   ███████   ██████  ░███████         ░███        ███      ░░   ██████   █████   ████████████   ░███   ██████ "
    " ░███████████  ░███░░██  ███░░░██ ░███░░███     ███████████   ░███          ███░░███ ███░░   ░███░░███░░███  ░███  ███░░░██"
    " ░███░░░░░███  ░███ ░░  ░███  ░░  ░███ ░███    ░░░░░███░░░    ░███         ░███ ░███░░█████  ░███ ░███ ░███  ░███ ░███  ░░ "
    " ░███    ░███  ░███     ░███   ██ ░███ ░███        ░███       ░░███      ██░███ ░███ ░░░░███ ░███ ░███ ░███  ░███ ░███   ██"
    " ░███    ░███  ░███     ░░██████  ░███ ░███        ░░░         ░░█████████ ░░██████  ██████  ░███ ░███ ░███  ░███ ░░██████ "
    " ░░░     ░░░   ░░░       ░░░░░░   ░░░  ░░░                      ░░░░░░░░░   ░░░░░░  ░░░░░░   ░░░  ░░░  ░░░   ░░░   ░░░░░░  "
  )

  logo_size=0
  for line in "${logo[@]}"; do
    if [ "${#line}" -gt "$logo_size" ]; then
      logo_size="${#line}"
    fi
  done

  local padding=$(( (TOTAL_COLUMNS - logo_size) / 2 ))

  printf "$COLOR"
  for line in "${logo[@]}"; do
    print_repeat " " "$padding"
    echo "$line"
  done
}

loading_bar() {
  local duration=${1:-1}
  local size=${2:-$TOTAL_COLUMNS}
  local interval=0.1
  local interval_tenths=1
  local duration_tenths

  if [[ "$duration" =~ ^[0-9]+$ ]]; then
    duration_tenths=$((duration * 10))
  elif [[ "$duration" =~ ^([0-9]+)\.([0-9])$ ]]; then
    duration_tenths=$((BASH_REMATCH[1] * 10 + BASH_REMATCH[2]))
  else
    duration_tenths=10
  fi

  local steps=$((duration_tenths / interval_tenths))
  ((steps < 1)) && steps=1
  local progress=0

  while [ "$progress" -lt "$steps" ]; do
    sleep $interval
    progress=$((progress + 1))
    progress_size=$((progress * size / steps))
    padding=$(( (TOTAL_COLUMNS - size) / 2 ))
    progress_padding_left=$(( (size - progress_size) / 2 ))
    progress_padding_right=$((size - progress_size - progress_padding_left))

    tput cuu1
    print_repeat " " "$padding"
    printf "$GRAY"
    print_repeat "░" "$progress_padding_left"
    printf "$COLOR"
    print_repeat "█" "$progress_size"
    printf "$GRAY"
    print_repeat "░" "$progress_padding_right"
    printf "\n"
  done
}

print_logo() {
  local logo=${1:-default}
  local duration=${2:-0}

  printf "\n\n"
  icon_logo

  printf "\n\n"
  case "$logo" in
    default)
      logo_default
      ;;
    *)
      echo "Unknown logo: $logo" >&2
      ;;
  esac

  local size=${3:-${logo_size:-$TOTAL_COLUMNS}}
  printf "\n\n"
  loading_bar "$duration" "$size"

  printf "\n\n"
}