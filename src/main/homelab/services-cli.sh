#!/bin/bash
# @file services-cli.sh
# @brief Command line interface to control docker-compose services.
#
# @description This script starts and stops docker-compose services on the respective machine.
# The script auto-detects the the services from the filesystem provides a select menu to choose
# a stack.
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly OPTION_START="start"
readonly OPTION_STOP="stop"
readonly OPTION_RESTART="restart"
readonly OPTION_LOGS="logs"

STACK=""


# @description Utility function to startup docker-compose services.
function docker_startup() {
  echo -e "$LOG_INFO Startup stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose up -d
}


# @description Utility function to shutdown docker-compose services.
function docker_shutdown() {
  echo -e "$LOG_INFO Shutdown stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose down -v --rmi all
}


# @description Utility function to show docker-compose logs.
function docker_logs() {
  echo -e "$LOG_INFO Show logs for stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose logs -f
}


# @description Utility function to provide the select menu for docker services.
function docker_menu() {
  (
    cd "$STACK" || exit

    echo -e "$LOG_INFO Select the action"
    select s in "$OPTION_START" "$OPTION_STOP" "$OPTION_RESTART" "$OPTION_LOGS"; do

      case "$s" in
        "$OPTION_START" )
          docker_startup
          break;;
        "$OPTION_STOP" )
          docker_shutdown
          break;;
        "$OPTION_RESTART" )
          docker_shutdown
          docker_startup
          break;;
        "$OPTION_LOGS" )
          docker_logs
          break;;
      esac

    done
  )
}


# @description Utility function to provide the select menu for terraform services.
function terraform_menu() {
  pwd
}

# @description Print information about the current system (= the host which is running this script).
function sysinfo() {
  grey='\033[1;30m'

  echo -e "$LOG_INFO Deploy docker services for machine $P$HOSTNAME$D"
  echo -e "$LOG_INFO ========== System Info ==================================================$grey"
  echo "        Hostname: $HOSTNAME"
  hostnamectl
  echo "          Kernel: $(uname -v)"
  echo -e "$D$LOG_INFO ========================================================================="
}


docker run --rm mwendler/figlet:latest 'Services CLI'
sysinfo
(
  cd services || exit
  
  echo -e "$LOG_INFO Select the type of service"
  select type in */; do
    echo "$type"

    (
      cd "$type" || exit
      echo -e "$LOG_INFO Select the services stack"
      select s in */; do
        STACK="${s::-1}"
        break
      done

      case $type in
        *"docker"*) docker_menu ;;
        *"terraform"*) terraform_menu ;;
      esac
    )

    break
  done
)
