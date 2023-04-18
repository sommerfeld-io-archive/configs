#!/bin/bash
# @file services-cli-monitoring.sh
# @brief Command line interface to control all containers from the monitoring stack.
#
# @description This script starts and stops all docker-compose services from the monitoring stack
# on your local machine (for testing purposes) or on the desired remote host (= the production
# environment). The script provides a select menu to choose between local testing and production
# deployments
#
# INCLUDE PLANTUML DIAGRAM HERE
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# readonly OPTION_START="start"
# readonly OPTION_STOP="stop"
# readonly OPTION_RESTART="restart"
# readonly OPTION_LOGS="logs"

# STACK=""
# MODE_TEST="localhost"
# MODE_PROD="prometheus.fritz.box"
