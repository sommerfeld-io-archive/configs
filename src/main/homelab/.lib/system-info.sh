#!/bin/bash
# @file system-info.sh
# @brief Utility script to print some information abount the current environment.
#
# @description This script is a utility scriptprints some information abount the current
# environment. This script is called from the ``services-*-cli.sh`` scripts.
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


grey='\033[1;30m'

echo -e "$LOG_INFO Deploy docker services for machine $P$HOSTNAME$D"
echo -e "$LOG_INFO ========== System Info ==================================================$grey"
echo "        Hostname: $HOSTNAME"
hostnamectl
echo "          Kernel: $(uname -v)"
echo " Ansible version: ..."
echo -e "$D$LOG_INFO ========================================================================="
