#!/bin/bash
# @file services-cli.sh
# @brief Command line interface to control docker-compose services.
#
# @description This script starts and stops docker-compose services on the respective machine.
# The script auto-detects the the services from the filesystem provides a select menu to choose
# a stack.
#
# ==== Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


OPTION_START="start"
OPTION_STOP="stop"
OPTION_RESTART="restart"
OPTION_LOGS="logs"

STACK=""


# @description Utility function to startup docker-compose services.
function startup() {
  echo -e "$LOG_INFO Startup stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose up -d
}


# @description Utility function to shutdown docker-compose services.
function shutdown() {
  echo -e "$LOG_INFO Shutdown stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose down -v --rmi all
}


# @description Utility function to show docker-compose logs.
function logs() {
  echo -e "$LOG_INFO Show logs for stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose logs -f
}


docker run --rm mwendler/figlet:latest 'Services CLI'
(
  cd services || exit

  echo -e "$LOG_INFO Deploy docker services for machine $P$HOSTNAME$D"
  echo -e "$LOG_INFO ========== System Info =================================================="
  echo "        Hostname: $HOSTNAME"
  hostnamectl
  echo "          Kernel: $(uname -v)"
  echo -e "$LOG_INFO ========================================================================="


  echo -e "$LOG_INFO Select the docker-compose stack"
  select s in */; do
    STACK="${s::-1}"
    break
  done


  (
    cd "$STACK" || exit

    echo -e "$LOG_INFO Select the action"
    select s in "$OPTION_START" "$OPTION_STOP" "$OPTION_RESTART" "$OPTION_LOGS"; do

      case "$s" in
        "$OPTION_START" )
          startup
          break;;
        "$OPTION_STOP" )
          shutdown
          break;;
        "$OPTION_RESTART" )
          shutdown
          startup
          break;;
        "$OPTION_LOGS" )
          logs
          break;;
      esac

    done
  )
)
