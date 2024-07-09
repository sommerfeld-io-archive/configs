#!/bin/bash
## This script prints some information about the system including the OS version and some hardware information.
##
## The Ansible playbook ensures that this script can be called through the alias `systen-info`.
##
## === Usage
## [source, bash]
## ....
## ./system-info.sh
## system-info
## ....
##
## The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


echo -e "$LOG_INFO ========== System Info =================================================="
echo "        Hostname: $HOSTNAME"
hostnamectl
echo "          Kernel: $(uname -v)"
echo -e "$LOG_INFO ========================================================================="
