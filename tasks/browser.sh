#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

SKIP_AUR_HELPER=false

for arg in "$@"; do
    case $arg in
        --skip-aur-helper)
            SKIP_AUR_HELPER=true
            ;;
        *)
    esac
done

BROWSER_AUR_LIST=(
    "google-chrome"
    "brave-bin"
    "microsoft-edge-stable-bin"
    "zen-browser-bin"
)

BROWSER="${1:-firefox}"
if [ "$SKIP_AUR_HELPER" = true ] && [[ " ${BROWSER_AUR_LIST[@]} " =~ " $BROWSER " ]]; then
  BROWSER="firefox"
fi

# ###########################################################
# Browser
# ###########################################################
IS_OFFICIAL=$([[ "$BROWSER" != "google-chrome" ]] && echo true || echo false)
install_official_or_aur "$IS_OFFICIAL" \
  "$BROWSER" \
  "$BROWSER"