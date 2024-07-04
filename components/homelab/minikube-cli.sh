#!/bin/bash
# @file minikube-cli.sh
# @brief Script to manage minikube.
#
# @description This script controls the local minikube instance. This setup includes Minikube and
# Docker Compose stacks. This script exclusively manages Minikube and Helm, while a
# xref:AUTO-GENERATED:components/homelab/docker-stacks-cli-sh.adoc[separate script] handles the
# Docker Compose stacks. Minikube will not fail if the Docker Compose stacks are not running.
#
# [ditaa, ditaa-image, svg]
#
# ....
# +------------------------------------------------------------+
# |  Workstation                                               |
# |                                                            |
# |    +--------------------+        +--------------------+    |          +----------------------+
# |    | DockerCompose: ops |        |  minikube          |    |          |  DockerHub           |
# |    |                    |        |                    |    |          |                      |
# |    |  +--------------+  |        |  +--------------+  |    |   Helm   |  +----------------+  |
# |    |  | Portainer    |  |        |  | krokidile    |<--------------------+  krokidile     |  |
# |    |  +--------------+  |        |  +--------------+  |    |          |  +----------------+  |
# |    |                    |        |                    |    |          |                      |
# |    |  +--------------+  |        |  +--------------+  |    |   Helm   |  +----------------+  |
# |    |  | cAdvisor     +------+    |  | ... app ...  |<--------------------+  ... app ...   |  |
# |    |  +--------------+  |   |    |  +--------------+  |    |          |  +----------------+  |
# |    |                    |   |    |                    |    |          +----------------------+
# |    |  +--------------+  |   |    |                    |    |
# |    |  | NodeExporter +------+    |   +----------------+    |
# |    |  +--------------+  |   |    |   | metrics server |    |
# |    +--------------------+   |    +---+---+------------+    |
# |                             |            |                 |
# |                             +------------+                 |
# |                             |                              |
# |    +--------------------+   |                              |
# |    | DockerCompose      |   |                              |
# |    |                    |   |                              |
# |    |  +--------------+  |   :                              |
# |    |  | Prometheus   |<-----+                              |
# |    |  +--+-----------+  |                                  |
# |    |     |              |                                  |
# |    |     v              |                                  |
# |    |  +--------------+  |                                  |
# |    |  | Grafana      |  |                                  |
# |    |  +--------------+  |                                  |
# |    +--------------------+                                  |
# |                                                            |
# +------------------------------------------------------------+
# ....
#
# === About minikube and Helm
#
# link:https://minikube.sigs.k8s.io/docs[minikube] is a tool that simplifies running Kubernetes
# clusters locally. It allows developers to set up a single-node Kubernetes cluster on their local
# workstation, which is useful for development, testing, and learning purposes. minikube supports
# various hypervisors (like VirtualBox, KVM, Hyper-V) and container runtimes (like Docker, Podman,
# containerd, and CRI-O). By providing a local Kubernetes environment, minikube helps developers
# emulate the behavior of a production cluster, enabling them to test Kubernetes applications in a
# controlled, local setup before deploying them to a larger, more complex cluster.
#
# link:https://helm.sh[Helm] is a package manager for Kubernetes, designed to streamline the
# deployment, management, and scaling of applications on Kubernetes clusters. It uses "charts",
# which are packages of pre-configured Kubernetes resources, to define, install, and upgrade
# Kubernetes applications. Helm helps automate the deployment process, manage dependencies, and
# simplify updates and rollbacks, making it easier to manage Kubernetes applications consistently
# and reproducibly.
#
# === Usage
#
# This script allows to start, stop and expose the dashboard (among others). Common commands are
# available as options. The script is interactive and will prompt the user to select an action.
# More specific actions need to be executed directly with minikube.
#
# The script does not accept any parameters.
#
# [source, bash]
# ```
# ./minikube-cli.sh
# ```
#
# == Prerequisites
#
# A local Docker and a local minikube installation is required. To deploy applications to the
# cluster, Helm is also required.
#
# Keep in mind, that the Ansible playbook create a ``kubectl`` alias which points to
# ``minikube kubectl`` so this might conflict with other ``kubectl`` installations.
#
# == See
#
# * Initial implementation issue: https://github.com/sebastian-sommerfeld-io/configs/issues/1421


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly OPTION_START="start"
readonly OPTION_STOP="stop"
readonly OPTION_DASHBOARD="dashboard"
readonly OPTION_PODS="list-pods"
readonly OPTION_INFO="info"
readonly OPTION_HELP="help"


# @description Utility function to startup minikube.
function startup() {
  echo -e "$LOG_INFO Startup minikube on ${P}${HOSTNAME}${D}"
  minikube start

  sleep 3s

  echo -e "$LOG_INFO Startup metrics-server"
  minikube addons enable metrics-server
}


# @description Utility function to shutdown minikube.
function shutdown() {
  echo -e "$LOG_INFO Shutdown minikube on ${P}${HOSTNAME}${D}"
  minikube stop
}


# @description Utility function to expose the minikube dashboad.
function dashboard() {
  echo -e "$LOG_INFO Expose the minikube dashboard"
  minikube dashboard
}


# @description Utility function to expose the minikube dashboad.
function pods() {
  echo -e "$LOG_INFO List pods from all namespaces"
  minikube kubectl -- get po -A
}


# @description Utility function to display minikube status and some metadata.
function info() {
  echo -e "$LOG_INFO minikube version"
  minikube version

  echo -e "$LOG_INFO minikube status"
  minikube status

  echo -e "$LOG_INFO Helm version"
  helm version
}


# @description Utility function to display the minikube help.
function help() {
  echo -e "$LOG_INFO minikube help"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  echo -e "$LOG_WARN Remember to use minikube directly when invoking commands that are not supported by this script"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  minikube
}


echo -e "$LOG_INFO Select the action"
select s in "$OPTION_START" "$OPTION_STOP" "$OPTION_DASHBOARD" "$OPTION_PODS" "$OPTION_INFO" "$OPTION_HELP"; do
    case "$s" in
    "$OPTION_START" )
        startup
        break;;
    "$OPTION_STOP" )
        shutdown
        break;;
    "$OPTION_DASHBOARD" )
        dashboard
        break;;
    "$OPTION_PODS" )
        pods
        break;;
    "$OPTION_INFO" )
        info
        break;;
    "$OPTION_HELP" )
        help
        break;;
    esac
done

# helm install krokidile ./krokidile
# minikube service krokidile -n apps
# helm uninstall krokidile
