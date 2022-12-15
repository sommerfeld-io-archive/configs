#!/bin/bash
# @file apply-config.sh
# @brief Apply Github config for all repositories based.
#
# @description This script applies a consistent configuration across all
# link:https://github.com/sebastian-sommerfeld-io?tab=repositories[Github repositories]. using 
# Terraform. The link:https://registry.terraform.io/providers/integrations/github/latest/docs[Terraform Github Provider]
# allows interaction with Github. Terraform is started inside a docker container, so there is no
# need to install Terraform on your machine.
#
# Terraform is an open-source infrastructure as code software tool that enables you to safely and
# predictably create, change, and improve infrastructure. It provides infrastructure automation with
# workflows to build composition, collaboration, and reuse of infrastructure as code.
#
# TODO Link to pipeline
#
# .Available Terraform commands
# include::ROOT:partial$GENERATED/github/config/help.adoc[]
#
# To run this script locally, run the commands in the same order as the pipeline does (see docs for
# each function).
#
# TODO link to run-in-pipeline-order.sh / simulate-pipeline.sh
#
# === Script Arguments
#
# * *$1* (string): The ``terraform`` command to run.
#
# === Script Example
#
# [source, bash]
# ```
# ./apply-config.sh
# ```


TF_COMMAND="$1"
if [ -z "$TF_COMMAND" ]; then
  echo -e "$LOG_ERROR Param missing: Terraform command"
  echo -e "$LOG_ERROR Available parameters are:"
  cat assets/help.adoc
  echo -e "$LOG_ERROR exit" && exit 8
fi
readonly TF_COMMAND


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


TOKEN="$(cat .secrets/github.token)"
readonly TOKEN


readonly OPTION_APPLY="apply"
readonly OPTION_FORMAT="fmt"
readonly OPTION_INITIALIZE="init"
readonly OPTION_PLAN="plan"
readonly OPTION_VALIDATE="validate"
readonly OPTION_VERSION="-version"


# @description Wrapper function to encapsulate terraform in a docker container. The current working
# directory is mounted into the container and selected as working directory so that all file are
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
  
  docker run --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --env "GITHUB_TOKEN=$TOKEN" \
    hashicorp/terraform:1.3.6 "$@"
}


# @description Apply this configuration by running ``terraform apply -auto-approve``.
# Pipeline Step 6.
#
# @example
#    apply
function apply() {
  terraform apply -auto-approve
}


# @description Apply consistent format to all .tf files by running ``terraform fmt -recursive``.
# Pipeline Step 4.
#
# @example
#    fmt
function format() {
  terraform fmt -recursive
}


# @description Initialize this configuration by running ``terraform init``.
# Pipeline Step 2.
#
# @example
#    initialize
function initialize() {
  terraform init
}


# @description Plan this configuration by running ``terraform plan``.
# Pipeline Step 5.
#
# @example
#    plan
function plan() {
  terraform plan
}


# @description Validate Terraform configuration by running ``terraform validate``.
# Pipeline Step 3.
#
# @example
#    validate
function validate() {
  terraform validate
}


# @description Show Terraform version by running ``terraform -version``.
# Pipeline Step 1.
#
# @example
#    version
function version() {
  terraform -version
}


echo -e "$LOG_INFO Run Github configuration steps: $TF_COMMAND"
case "$TF_COMMAND" in
  "$OPTION_APPLY" ) apply ;;
  "$OPTION_FORMAT" ) format ;;
  "$OPTION_INITIALIZE" ) initialize ;;
  "$OPTION_PLAN" ) plan ;;
  "$OPTION_VALIDATE" ) validate ;;
  "$OPTION_VERSION" ) version ;;
esac
