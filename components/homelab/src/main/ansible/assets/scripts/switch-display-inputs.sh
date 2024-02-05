#!/bin/bash
# @file switch-display-inputs.sh
# @brief Switch display inputs for my Dell monitors from script.
#
# @description This script switches the display inputs for my Dell monitors to
# avoid having to use the monitors physical buttons.
#
# The Ansible playbook ensures that this script can be called through the alias
# ``switch-display-inputs``.
#
# The script is designed to only work on the ``caprica`` host and fails if
# another machine runs this script.
#
# === Script Arguments
#
# * *$1* (string): The active workstation that should use both monitors
#
# === Script Example
#
# [source, bash]
# ```
# ./switch-display-inputs.sh caprica # My main linux workstation
# ./switch-display-inputs.sh provinzial # My office notebook
# ```
#
# == Prerequisites
#
# The ``ddcutil`` package must be installed. The ``ddcui`` package can be used
# to get information about the screens.


readonly ALLOWED_HOST="caprica"
readonly TARGET_CAPRICA="caprica"
readonly TARGET_WORK="provinzial"


if [[ ! "$HOSTNAME" == "$ALLOWED_HOST" ]]; then
    echo -e "$LOG_ERROR Script is only allowed to run on host '$ALLOWED_HOST'"
    echo -e "$LOG_ERROR exit" && exit 8
fi

TARGET="$1"
if [ -z "$TARGET" ]; then
    echo -e "$LOG_INFO No target workstation passed"
    select t in "$TARGET_CAPRICA" "$TARGET_WORK"; do
        TARGET="$t"
        break
    done
fi


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly MONITOR_LEFT="5" # Curved (landscape) /dev/i2c-5
readonly MONITOR_RIGHT="4" # UHD (portrait) /dev/i2c-4

readonly CHANGE_INPUT_SOURCE="0x60"
readonly SOURCE_HDMI_1="0x11"
readonly SOURCE_HDMI_2="0x12"
readonly SOURCE_DP="0x0f"

case "$TARGET" in
    "$TARGET_CAPRICA")
        ddcutil -b "$MONITOR_LEFT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_DP"
        ddcutil -b "$MONITOR_RIGHT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_HDMI_1"
    ;;
    "$TARGET_WORK")
        ddcutil -b "$MONITOR_LEFT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_HDMI_2"
        ddcutil -b "$MONITOR_RIGHT" setvcp "$CHANGE_INPUT_SOURCE" "$SOURCE_HDMI_2"
    ;;
    *)
        echo -e "$LOG_ERROR No valid workstation passed"
        echo -e "$LOG_ERROR Allowed values are '$ALLOWED_HOST' and 'provinzial'"
        echo -e "$LOG_ERROR exit" && exit 8
    ;;
esac
