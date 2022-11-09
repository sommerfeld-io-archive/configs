#!/bin/bash
# @file provision.sh
# @brief Run basic provisioning.
#
# @description This script runs the basic provisioning. This is a prerequisite to run the ansible steps.
#
# ==== Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


echo -e "$LOG_INFO Install curl"
echo -e "$LOG_WARN todo ..."

echo -e "$LOG_INFO Install git"
echo -e "$LOG_WARN todo ..."

echo -e "$LOG_INFO Install docker"
echo -e "$LOG_WARN todo ..."
