#!/bin/bash
# @file services-terraform-cli.sh
# @brief Command line interface to control services managed by Terraform configurations.
#
# @description This script controls services managed by link:https://www.terraform.io[Terraform]
# configurations. The script auto-detects the the services from the filesystem and provides a
# select menu to choose a configuration.
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly OPTION_INIT="init"
readonly OPTION_PLAN="plan"
readonly OPTION_APPLY="apply"
readonly OPTION_DESTROY="destroy"

readonly TF_PLAN_FILE="tfplan"
readonly VAGRANT_SSH_CONFIG=".vagrant-ssh.config"

STACK=""


# @description Wrapper function to encapsulate terraform in a Docker container. The current working
# directory is mounted into the container and selected as working directory so that all files are
# available to terraform. Paths are preserved. The container runs with the current user.
# 
# @example
#    terraform -version
#
# @arg $@ String The terraform commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with terraform command is missing
function terraform() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the terraform container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi
  
  docker run -it --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    hashicorp/terraform:1.4.5 "$@"
}


# @description Utility function to initialize terraform using ``terraform init``.
function init() {
  echo -e "$LOG_INFO Run $P$OPTION_INIT$D for stack $P$STACK$D"

  vagrant up
  terraform init
  vagrant ssh-config > "$VAGRANT_SSH_CONFIG"
}


# @description Utility function to run ``terraform plan``.
function plan() {
  echo -e "$LOG_INFO Run $P$OPTION_PLAN$D for stack $P$STACK$D"
  
  terraform validate
  terraform fmt -recursive

  docker run --rm \
    --volume "$(pwd):/data" \
    ghcr.io/terraform-linters/tflint-bundle:latest

  terraform plan -out="$TF_PLAN_FILE"
}


# @description Utility function to run ``terraform apply``.
function apply() {
  echo -e "$LOG_INFO Run $P$OPTION_APPLY$D for stack $P$STACK$D"

  terraform apply -auto-approve "$TF_PLAN_FILE"
  rm "$TF_PLAN_FILE"
}


# @description Utility function to run ``terraform destroy``.
#
# CAUTION: Be aware that there is no request for confirmation! Also ``terraform plan -destroy`` is
# not used! All resources are destroyed right away!
function destroy() {
  echo -e "$LOG_INFO Run $P$OPTION_DESTROY$D for stack $P$STACK$D"

  vagrant halt
  vagrant destroy -f

  rm -rf .vagrant
  rm -f "$VAGRANT_SSH_CONFIG"
  rm -rf .terraform
  rm -f .terraform.lock*
  rm -f "$TF_PLAN_FILE"*
}


docker run --rm mwendler/figlet:latest 'Terraform'
bash .lib/system-info.sh

(
  cd services/terraform || exit

  echo -e "$LOG_INFO Select the terraform configuration"
  select s in */; do
    STACK="${s::-1}"
    break
  done

  (
    cd "$STACK" || exit

    echo -e "$LOG_INFO Select the action"
    select s in "$OPTION_INIT" "$OPTION_PLAN" "$OPTION_APPLY" "$OPTION_DESTROY"; do
      case "$s" in
        "$OPTION_INIT" )
          init
          break;;
        "$OPTION_PLAN" )
          plan
          break;;
        "$OPTION_APPLY" )
          apply
          break;;
        "$OPTION_DESTROY" )
          destroy
          break;;
      esac
    done
  )
)
