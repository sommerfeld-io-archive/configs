#!/bin/bash
# @file run-local.sh
# @brief Wrapper script to apply the Github configuration during development from localhost in an
# easier way.
#
# @description This script is just a wrapper script to apply the Github configuration during
# development from localhost in an easier way. It provides a menu to select the action of choise
# and delegates all commands to `apply-config.sh`.
#
# === Script Arguments
#
# The script does not accept any parameters.
# * *$1* (string): Some var
#
# === Script Example
#
# [source, bash]
# ```
# ./run-local.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


echo -e "$LOG_INFO Run $0"
