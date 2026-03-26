#!/usr/bin/env bash
set -euo pipefail
source "helpers.sh"

# ###########################################################
# Serial port access for IoT development
# ###########################################################
echo "=> Serial port access for IoT development..."
sudo usermod -a -G uucp $USER