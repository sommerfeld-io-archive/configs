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


echo -e "$LOG_INFO Deploy docker services for machine $P$HOSTNAME$D"
echo -e "$LOG_INFO $G========== System Info =================================================="
echo "        Hostname: $HOSTNAME"
hostnamectl
echo "          Kernel: $(uname -v)"
echo -e "$D$LOG_INFO $G========================================================================="
echo "  Docker version: $(docker --version)"
echo -e "$D$LOG_INFO $G========================================================================="
echo " Ansible version: $(ansible --version)"
echo -e "$D$LOG_INFO $G=========================================================================$D"
