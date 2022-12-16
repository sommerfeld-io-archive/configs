#!/bin/bash
# @file apply-config.sh
# @brief Apply a consistent configuration for all (relevant) Github repositories.
#
# @description This script applies a consistent configuration across all
# link:https://github.com/sebastian-sommerfeld-io?tab=repositories[Github repositories]. using
# Terraform. The link:https://registry.terraform.io/providers/integrations/github/latest/docs[Terraform Github Provider]
# allows interaction with Github.
#
# Terraform is started inside a link:https://www.docker.com/[Docker] container, so there is no need
# to install Terraform or any other software other than Docker on your machine.
#
# Terraform is an open-source infrastructure as code software tool that enables you to safely and
# predictably create, change, and improve infrastructure. It provides infrastructure automation with
# workflows to build composition, collaboration, and reuse of infrastructure as code.
#
# .Github Actions workflow
# link:https://github.com/sebastian-sommerfeld-io/configs/actions/workflows/configure-github.yml[Apply global Github config]
#
# .Available Terraform commands
# include::ROOT:partial$GENERATED/github/config/help.adoc[]
#
# TODO link to run-in-pipeline-order.sh / simulate-pipeline.sh
#
# === Script Arguments
#
# * *$1* (string): The ``terraform`` command to run.
# * *$2* (string): Github token ... when running on localhost pass a token from anywhere, when running in a Github Actions workflow pass ``${{ secrets.GITHUB_TOKEN }}``
#
# === Script Example
#
# To run this script locally, run the commands in the same order as the pipeline does (see docs for
# each function). Running this script without arguments will result in an error.
#
# [source, bash]
# ```
# ./apply-config.sh init "$TOKEN"
# ./apply-config.sh lint "$TOKEN"
# ./apply-config.sh validate "$TOKEN"
# ./apply-config.sh fmt "$TOKEN"
# ./apply-config.sh plan "$TOKEN"
# ./apply-config.sh apply "$TOKEN"
# ```


# Avoid 'unbound variable' errors in pipeline
readonly LOG_ERROR="[\e[1;31mERROR\e[0m]"
readonly LOG_INFO="[\e[34mINFO\e[0m]"


TF_COMMAND="$1"
if [ -z "$TF_COMMAND" ]; then
  echo -e "$LOG_ERROR Param missing: Terraform command"
  echo -e "$LOG_ERROR Available arguments are:"
  cat assets/help.adoc
  echo -e "$LOG_ERROR exit" && exit 8
fi
readonly TF_COMMAND


TOKEN="$2"
if [ -z "$TF_COMMAND" ]; then
  echo -e "$LOG_ERROR Param missing: Github Token"
  echo -e "$LOG_ERROR exit" && exit 8
fi
readonly TOKEN


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly OPTION_APPLY="apply"
readonly OPTION_FORMAT="fmt"
readonly OPTION_INITIALIZE="init"
readonly OPTION_LINT="lint"
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
# Pipeline Step 7.
#
# @example
#    apply
function apply() {
  terraform apply -auto-approve
}


# @description Apply consistent format to all .tf files by running ``terraform fmt -recursive``.
# Pipeline Step 5.
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


# @description Use link:https://github.com/terraform-linters/tflint[terraform-linters/tflint] linter
# to check terraform config (specifically
# link:https://github.com/terraform-linters/tflint-bundle[terraform-linters/tflint-bundle]).
# Pipeline Step 3.
#
# @example
#    lint
function lint() {
  docker run --rm \
    --volume "$(pwd):/data" \
    ghcr.io/terraform-linters/tflint-bundle:latest
}


# @description Plan this configuration by running ``terraform plan``.
# Pipeline Step 6.
#
# @example
#    plan
function plan() {
  terraform plan
}


# @description Validate Terraform configuration by running ``terraform validate``.
# Pipeline Step 4.
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
  "$OPTION_LINT" ) lint ;;
  "$OPTION_PLAN" ) plan ;;
  "$OPTION_VALIDATE" ) validate ;;
  "$OPTION_VERSION" ) version ;;
  * )
    echo -e "$LOG_ERROR Invalid argument"
    echo -e "$LOG_ERROR Available arguments are:"
    cat assets/help.adoc
    ;;
esac
