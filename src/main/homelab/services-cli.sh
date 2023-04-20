#!/bin/bash
# @file services-cli.sh
# @brief Command line interface to control Docker Compose services on your local machine.
#
# @description This Bash script that acts as a command line interface to control Docker Compose
# services on your local machine. The script provides an easy-to-use interface for managing your
# Docker Compose services, allowing you to start, stop, and restart your containers with a few
# simple commands. It is intended to simplify the management of Docker Compose services by providing
# a set of convenient and intuitive commands that allow you to control your containers quickly and
# easily.
#
# The script auto-detects the services from the filesystem and provides a select menu to
# choose a stack. Once you select the stack, the script will provide you with a set of commands to
# manage the containers within from the respective Docker Compose definition.
#
# This script is intended to simplify the management of Docker Compose services on your local
# machine. It provides a convenient, consistent and repoducible way to manage the Docker containers
# through an easy-to-use interface that allows you to control your containers quickly and
# efficiently.
#
# === Prerequisites
#
# Before using this script, you need to ensure that Docker and Docker Compose is installed on the
# system. The script assumes that the Docker engine is running, and the user has necessary
# permissions to execute Docker commands.
#
# === Docker Compose Stacks
#
# ==== Stack: monitoring.fritz.box
#
# include::ROOT:partial$homelab/services/docker/monitoring-fritz-box.adoc[]
#
# ==== Stack: supervisor.fritz.box
#
# include::ROOT:partial$homelab/services/docker/supervisor-fritz-box.adoc[]
#
# ==== Stack: ops
#
# include::ROOT:partial$homelab/services/docker/ops.adoc[]
#
# ==== Stack: sommerfeld-io
#
# include::ROOT:partial$homelab/services/docker/sommerfeld-io.adoc[]
#
# ==== Stack: websites
#
# include::ROOT:partial$homelab/services/docker/websites.adoc[]
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


docker run --rm mwendler/figlet:latest 'Docker Localhost'
bash .lib/system-info.sh

(
  cd services/docker || exit

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
