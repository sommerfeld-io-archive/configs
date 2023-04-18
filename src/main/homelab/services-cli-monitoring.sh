#!/bin/bash
# @file services-cli-monitoring.sh
# @brief Command line interface to control all containers from the monitoring stack.
#
# @description This script starts and stops all docker-compose services from the monitoring stack
# on your local machine (for testing purposes) or on the desired remote host (= the production
# environment). The script provides a select menu to choose between local testing and production
# deployments
#
# [plantuml, rendered-plantuml-image, svg]
# ....
# include::ROOT:image$bash-docs/services-cli-monitoring.puml[]
# ....
#
# The following services are accessible through their respective web ui.
#
# | Container           | URL                                     |
# | ------------------- | --------------------------------------- |
# | ``prom/prometheus`` | http://monitoring.fritz.box:9090 (prod) |
# | ``grafana/grafana`` | http://monitoring.fritz.box:3000 (prod) |
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly OPTION_TEST="localhost"
readonly OPTION_PROD="monitoring.fritz.box"
HOST=""

readonly OPTION_START="start"
readonly OPTION_STOP="stop"
readonly OPTION_RESTART="restart"


readonly BASE_PATH="services/docker"
readonly STACK_MONITORING="$BASE_PATH/monitoring.fritz.box"
readonly STACK_OPS="$BASE_PATH/ops"


# @description Utility function to startup docker-compose services.
function startup() {
stack="$STACK_OPS"
  (
    cd "$stack" || exit
    echo -e "$LOG_INFO Startup stack $P$stack$D on $P$HOST$D"
    docker-compose up -d
  )

  stack="$STACK_MONITORING"
  (
    cd "$stack" || exit
    echo -e "$LOG_INFO Startup stack $P$stack$D on $P$HOST$D"
    docker-compose up -d
  )
}


# @description Utility function to shutdown docker-compose services.
function shutdown() {
  stack="$STACK_MONITORING"
  (
    cd "$stack" || exit
    echo -e "$LOG_INFO Shutdown stack $P$stack$D on $P$HOST$D"
    docker-compose down -v --rmi all
  )

  stack="$STACK_OPS"
  (
    cd "$stack" || exit
    echo -e "$LOG_INFO Shutdown stack $P$stack$D on $P$HOST$D"
    docker-compose down -v --rmi all
  )
}


docker run --rm mwendler/figlet:latest 'Monitoring'
bash .lib/system-info.sh

echo -e "$LOG_INFO Select the target host"
select s in "$OPTION_TEST" "$OPTION_PROD"; do
  HOST="$s"
  break
done

echo -e "$LOG_INFO Select the action"
select s in "$OPTION_START" "$OPTION_STOP" "$OPTION_RESTART"; do
  case "$s" in
    "$OPTION_START" )
      startup
      ;;
    "$OPTION_STOP" )
      shutdown
      ;;
    "$OPTION_RESTART" )
      shutdown
      startup
      ;;
  esac

  break
done