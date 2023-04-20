#!/bin/bash
# @file services-cli.sh
# @brief Command line interface to control docker-compose services on your local machine.
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
# === Docker Stacks
#
# ==== Stack: monitoring.fritz.box
#
# All clients (including all RasPi nodes) report their metrics to ``prometheus``. This allows for
# centralized collection of metrics from all clients, which can then be analyzed and visualized
# using a web-based UI provided by Grafana.
#
# [plantuml, rendered-plantuml-image, svg]
# ....
# include::ROOT:image$bash-docs/services-cli-monitoring.puml[]
# ....
#
# The services listed below are accessible through their respective web UI.
#
# . link:https://prometheus.io[Prometheus] is an open-source monitoring system that collects metrics from various sources and stores them in a time-series database.
# . link:https://grafana.com[Grafana] is an open-source analytics and monitoring platform. It provides a web-based UI that allows users to visualize and analyze data from (in this case) Prometheus.
#
# | Container           | URL                                     |
# | ------------------- | --------------------------------------- |
# | ``prom/prometheus`` | http://monitoring.fritz.box:9090 (prod) |
# | ``grafana/grafana`` | http://monitoring.fritz.box:3000 (prod) |
#
# When you start the monitoring stack on your local machine, the same ports are used as in the
# production instance and when started will collect data from all configured sources, just as it
# does in the production instance. This allows you to test the monitoring stack locally and ensure 
# that it is configured correctly before deploying it to production. Additionally, you can use the
# local monitoring stack to develop and test new dashboards and alerts before deploying them to the
# production environment.
#
# ==== Stack: supervisor.fritz.box
#
# There is another Prometheus-Grafana stack that will only exist temporarily
# (``supervisor.fritz.box``). This temporary stack will be set up to monitor the actual
# Prometheus-Grafana setup (``monitoring.fritz.box``) to check if the host's resources are
# sufficient. This will help ensure that the monitoring stack is running efficiently and that
# there are no performance issues. Once the temporary stack has completed its monitoring task,
# (i.e. ``monitoring.fritz.box`` works withput performance issues) it can be taken down to
# conserve resources.
#
# The services listed below are accessible through their respective web UI.
#
# | Container           | URL                                     |
# | ------------------- | --------------------------------------- |
# | ``prom/prometheus`` | http://supervisor.fritz.box:9090 (prod) |
# | ``grafana/grafana`` | http://supervisor.fritz.box:3000 (prod) |
#
# ==== Stack: ops
#
# The ``ops`` Docker stack is a Docker Compose configuration that manages all of the needed exporters
# to monitor system metrics with Prometheus and Grafana. Additionally, it starts a local Portainer
# instance. By using the Ops Docker stack, you can quickly and easily deploy all of the necessary
# components for monitoring your system metrics. This includes exporters for various system metrics,
# such as CPU usage, disk usage, and network activity. The local Portainer instance makes it easy to
# manage and monitor the Docker containers running in the Ops Docker stack.
#
# ==== Stack: sommerfeld-io
#
# The ``sommerfeld-io`` Docker stack is a Docker Compose configuration for the website
# https://www.sommerfeld.io. This Docker Compose configuration is used to start the website locally
# in a Docker container.
#
# ==== Stack: websites
#
# The ``websites`` Docker stack is a Docker Compose configuration for the websites
# https://www.masterblender.de, https://www.tafelbox.de and https://www.numero-uno.de. This Docker
# Compose configuration is used to start these websites locally in Docker containers.
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
