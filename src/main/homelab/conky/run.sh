#!/bin/bash
# @file provision.sh
# @brief Run Conky instances on kobol laptop.
#
# @description The script starts all Conky instances. Normally this script is triggered automatically
# when the machine starts (the script is configured as a startup application by ansible playbook).
#
# === Script Arguments
#
# The script does not accept any parameters.


readonly CONKY_PATH="$HOME/work/repos/sebastian-sommerfeld-io/configs/src/main/homelab/conky"


echo -e "$LOG_INFO Copy launcher to autostart"
cp "assets/conky-launcher.desktop" "$HOME/.config/autostart/conky-launcher.desktop"

echo -e "$LOG_INFO Start all conky instances in background"
sleep 120

readonly conkyDefinitions=(
  "$CONKY_PATH/config-$HOSTNAME/.conkyrc"
  "$CONKY_PATH/config-$HOSTNAME/.conkyrc_services"
)
for def in "${conkyDefinitions[@]}"
do
  echo -e "$LOG_INFO Start Instance $def"
  sleep 10
  conky -c "$def" &
done
