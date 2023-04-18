#!/bin/bash
# @file services-cli-monitoring.sh
# @brief Command line interface to control all containers from the monitoring stack.
#
# @description This script is designed to start and stop the monitoring Docker stack either on
# your local machine (= development environment) or on the respective remote host (= production
# environment). The script provides a select menu to choose the environment.
#
# The purpose of this script is to provide a convenient, consistent and repoducible way to manage
# the Docker containers for the monitoring stack. With this script, you can quickly set up the
# monitoring stack on any given machine for development and production purposes.
#
# All clients (including all RasPi nodes) report their metrics to ``prometheus``. This allows for
# centralized collection of metrics from all clients, which can then be analyzed and visualized
# using a web-based UI provided by Grafana.
#
# However, there is another Prometheus-Grafana stack that will only exist temporarily
# (``auditor.fritz.box``). This temporary stack will be set up to monitor the actual
# Prometheus-Grafana setup (``monitoring.fritz.box``) to check if the host's resources are
# sufficient. This will help ensure that the monitoring stack is running efficiently and that
# there are no performance issues. Once the temporary stack has completed its monitoring task,
# (i.e. ``monitoring.fritz.box`` works withput performance issues) it can be taken down to
# conserve resources.
#
# [plantuml, rendered-plantuml-image, svg]
# ....
# include::ROOT:image$bash-docs/services-cli-monitoring.puml[]
# ....
#
# The services listed below are accessible through their respective web UI.
#
# | Container           | URL                                     |
# | ------------------- | --------------------------------------- |
# | ``prom/prometheus`` | http://monitoring.fritz.box:9090 (prod) |
# | ``grafana/grafana`` | http://monitoring.fritz.box:3000 (prod) |
#
# . Prometheus is an open-source monitoring system that collects metrics from various sources and stores them in a time-series database.
# . Grafana is an open-source analytics and monitoring platform. It provides a web-based UI that allows users to visualize and analyze data from (in this case) Prometheus.
#
# === Prerequisites
#
# Before using this script, you need to ensure that Docker and Docker Compose is installed on the
# system. The script assumes that the Docker engine is running, and the user has necessary
# permissions to execute Docker commands.
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