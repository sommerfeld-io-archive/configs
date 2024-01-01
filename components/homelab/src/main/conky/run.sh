#!/bin/bash
# @file provision.sh
# @brief Run Conky instances on kobol laptop.
#
# @description The script starts all Conky instances. By default this script is triggered
# automatically when the machine starts (the script is configured as a startup application
# by ansible playbook).
#
# === Script Arguments
#
# The script does not accept any parameters.


readonly BASE_PATH="$HOME/work/repos/sebastian-sommerfeld-io/configs/components/homelab/src/main/conky"
readonly CONKYRC_PATH="$BASE_PATH/conkyrc-$HOSTNAME"


echo -e "$LOG_INFO Copy launcher to autostart"
cp "assets/conky-launcher.desktop" "$HOME/.config/autostart/conky-launcher.desktop"

echo -e "$LOG_INFO Start all conky instances in background"
sleep 2m

for rc in "$CONKYRC_PATH"/*.conkyrc; do
  echo -e "$LOG_INFO Start Instance ${P}${rc}${D}"
  sleep 10s
  conky -c "$rc" &
done
