#!/bin/bash
# @file system-info.sh
# @brief Print information about the system (OS, hardware, etc).
#
# @description This script prints some information about the system including the OS version and some hardware information.
#
# The Ansible playbook ensures that this script can be called through the alias ``systen-info``.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./system-info.sh
# system-info
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


echo -e "$LOG_INFO ========== System Info =================================================="
echo "        Hostname: $HOSTNAME"
hostnamectl
echo "          Kernel: $(uname -v)"
echo -e "$LOG_INFO ========================================================================="
