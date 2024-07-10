#!/bin/bash
## This script controls the local minikube instance. This setup includes Minikube and
## Docker Compose stacks. This script exclusively manages Minikube and Helm, while a
## xref:AUTO-GENERATED:components/homelab/docker-stacks-cli-sh.adoc[separate script] handles the
## Docker Compose stacks. Minikube will not fail if the Docker Compose stacks are not running.
##
## [ditaa, ditaa-image, svg]
## ....
## +------------------------------------------------------------+
## |  Workstation                                               |
## |                                                            |
## |    +--------------------+        +--------------------+    |          +----------------------+
## |    | DockerCompose: ops |        |  minikube          |    |          |  DockerHub           |
## |    |                    |        |                    |    |          |                      |
## |    |  +--------------+  |        |  +--------------+  |    |   Helm   |  +----------------+  |
## |    |  | Portainer    |  |        |  | krokidile    |<--------------------+  krokidile     |  |
## |    |  +--------------+  |        |  +--------------+  |    |          |  +----------------+  |
## |    |                    |        |                    |    |          |                      |
## |    |  +--------------+  |        |  +--------------+  |    |   Helm   |  +----------------+  |
## |    |  | cAdvisor     +------+    |  | ... app ...  |<--------------------+  ... app ...   |  |
## |    |  +--------------+  |   |    |  +--------------+  |    |          |  +----------------+  |
## |    |                    |   |    |                    |    |          +----------------------+
## |    |  +--------------+  |   |    |                    |    |
## |    |  | NodeExporter +------+    |   +----------------+    |
## |    |  +--------------+  |   |    |   | metrics server |    |
## |    +--------------------+   |    +---+---+------------+    |
## |                             |            |                 |
## |                             +------------+                 |
## |                             |                              |
## |    +--------------------+   |                              |
## |    | DockerCompose      |   |                              |
## |    |                    |   |                              |
## |    |  +--------------+  |   :                              |
## |    |  | Prometheus   |<-----+                              |
## |    |  +--+-----------+  |                                  |
## |    |     |              |                                  |
## |    |     v              |                                  |
## |    |  +--------------+  |                                  |
## |    |  | Grafana      |  |                                  |
## |    |  +--------------+  |                                  |
## |    +--------------------+                                  |
## |                                                            |
# +------------------------------------------------------------+
## ....
##
## === About minikube and Helm
## link:https://minikube.sigs.k8s.io/docs[minikube] is a tool that simplifies running Kubernetes
## clusters locally. It allows developers to set up a single-node Kubernetes cluster on their local
## workstation, which is useful for development, testing, and learning purposes. minikube supports
## various hypervisors (like VirtualBox, KVM, Hyper-V) and container runtimes (like Docker, Podman,
## containerd, and CRI-O). By providing a local Kubernetes environment, minikube helps developers
## emulate the behavior of a production cluster, enabling them to test Kubernetes applications in a
## controlled, local setup before deploying them to a larger, more complex cluster.
##
## link:https://helm.sh[Helm] is a package manager for Kubernetes, designed to streamline the
## deployment, management, and scaling of applications on Kubernetes clusters. It uses "charts",
## which are packages of pre-configured Kubernetes resources, to define, install, and upgrade
## Kubernetes applications. Helm helps automate the deployment process, manage dependencies, and
## simplify updates and rollbacks, making it easier to manage Kubernetes applications consistently
## and reproducibly.
##
## === Usage
## This script allows to start, stop and expose the dashboard (among others). Common commands are
## available as options. The script is interactive and will prompt the user to select an action.
## More specific actions need to be executed directly with minikube.
##
## The script does not accept any parameters.
##
## [source, bash]
## ....
## # Start the script from its location in the filesystem
## ./minikube-cli.sh
##
## # Start the script through a bash alias (written by ansible playbook)
## minikube-cli
## ....
##
## Installing and uninstalling apps is done with Helm. The script does not handle Helm charts.
## Installing apps must be done manually. The following example shows how to install and uninstall
## the krokidile app.
##
## include::AUTO-GENERATED:partial$/admin-charts/portainer.adoc[]
##
## ==== Increasing the NodePort range
## By default, minikube only exposes ports `30000-32767`. If this does not work for you, you can
## adjust the range by using: `minikube start --extra-config=apiserver.service-node-port-range=1024-65535`
##
## == Prerequisites
## A local Docker and a local minikube installation is required. To deploy applications to the
## cluster, Helm is also required.
##
## Keep in mind, that the Ansible playbook creates a `kubectl` alias which points to
## `minikube kubectl` so this might conflict with other `kubectl` installations.
##
## == See
## * Initial implementation issue: https://github.com/sebastian-sommerfeld-io/configs/issues/1421


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly CHART_ADMIN="admin-chart"

readonly OPTION_START="start"
readonly OPTION_STOP="stop"
readonly OPTION_DASHBOARD="open-dashboard"
readonly OPTION_PODS="list-pods"
readonly OPTION_SERVICES="list-services"
readonly OPTION_STATUS="status"
readonly OPTION_HELP="help"
readonly OPTION_DESTROY="destroy"
readonly OPTION_DEPLOY_ADMIN="deploy-$CHART_ADMIN"
readonly OPTION_UNDEPLOY_ADMIN="undeploy-$CHART_ADMIN"


## Utility function to startup minikube.
function startup() {
  echo -e "$LOG_INFO Startup minikube on ${P}${HOSTNAME}${D}"
  minikube start

  sleep 5s

  echo -e "$LOG_INFO Startup metrics-server"
  minikube addons enable metrics-server

  echo -e "$LOG_INFO Startup ingress addon"
  minikube addons enable ingress
}


## Utility function to shutdown minikube.
function shutdown() {
  echo -e "$LOG_INFO Shutdown minikube on ${P}${HOSTNAME}${D}"
  minikube stop
}


## Utility function to expose the minikube dashboad.
function dashboard() {
  echo -e "$LOG_INFO Expose the minikube dashboard"
  minikube dashboard
}


## Utility function to list pods.
function pods() {
  echo -e "$LOG_INFO List pods from all namespaces"
  minikube kubectl -- get po -A
}


## Utility function to list services from all namespaces.
function services() {
  echo -e "$LOG_INFO List services from all namespaces"
  minikube service list # --namespace apps
}


## Utility function to display minikube status and some metadata.
function status() {
  echo -e "$LOG_INFO minikube version"
  minikube version

  echo -e "$LOG_INFO Helm version"
  helm version

  echo -e "$LOG_INFO minikube status"
  minikube status
}


## Utility function to display the minikube help.
function help() {
  echo -e "$LOG_INFO minikube help"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  echo -e "$LOG_WARN Remember to use minikube directly when invoking commands that are not supported by this script"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  minikube
}


## Utility function to delete the minkube instance and clean everything up.
function destroy() {
  echo -e "$LOG_INFO minikube destroy"
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  echo -e "$LOG_WARN The minikube instance will be deleted."
  echo -e "$LOG_WARN ----------------------------------------------------------------------------------------------"
  minikube delete
}


## Utility function to deploy a Helm chart.
##
## @arg $1 string The folder name containing the Helm charts (based in `components/homelab/src/main/minikube`).
## @arg $2 string The sub folder name containing the actual deployment configuration.
function deploy() {
  (
    cd "src/main/minikube/$1" || exit

    echo -e "$LOG_INFO Deploy ${P}$2${D} from Helm chart ${P}$1${D}"
    helm install "$2" "./$2"
  )
}


## Utility function to undeploy a Helm chart.
##
## @arg $1 string The sub folder name (= the release name) of the actual deployment configuration.
function undeploy() {
  (
    echo -e "$LOG_INFO Undeploy ${P}$1${D}"
    helm uninstall "$1"
  )
}


echo -e "$LOG_INFO Select the action"
select s in "$OPTION_START" \
            "$OPTION_STOP" \
            "$OPTION_DASHBOARD" \
            "$OPTION_DEPLOY_ADMIN" \
            "$OPTION_UNDEPLOY_ADMIN" \
            "$OPTION_PODS" \
            "$OPTION_SERVICES" \
            "$OPTION_STATUS" \
            "$OPTION_HELP" \
            "$OPTION_DESTROY"
  do
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
    "$OPTION_DEPLOY_ADMIN" )
        deploy "$CHART_ADMIN" portainer
        break;;
    "$OPTION_UNDEPLOY_ADMIN" )
        undeploy portainer
        break;;
    "$OPTION_PODS" )
        pods
        break;;
    "$OPTION_SERVICES" )
        services
        break;;
    "$OPTION_STATUS" )
        status
        break;;
    "$OPTION_HELP" )
        help
        break;;
    "$OPTION_DESTROY" )
        destroy
        break;;
    esac
done
