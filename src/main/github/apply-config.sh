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
# Github Actions workflow: # link:https://github.com/sebastian-sommerfeld-io/configs/actions/workflows/configure-github.yml[Apply global Github config]
#
# .Available Terraform commands
# include::ROOT:partial$GENERATED/github/config/help.adoc[]
#
# Use `xref:AUTO-GENERATED:bash-docs/src/main/github/run-local-sh.adoc[run-local.sh]` while developing
# on your localhost instead of direct calls to this script. `run-local.sh` provides a more conviniert
# way to trigger the terraform commands.
#
# === Script Arguments
#
# * *$1* (string): The ``terraform`` command to run - _Mandatory_
# * *$2* (string): Github token ... when running on localhost pass a token from anywhere, when running in a Github Actions workflow pass ``${{ secrets.GITHUB_TOKEN }}`` - _Mandatory for ``plan`` and ``apply``_
# * *$3* (string): Bitwarden client id ... when running on localhost pass a data from anywhere, when running in a Github Actions workflow pass the correct Actions secret - _Mandatory for ``plan`` and ``apply``_
# * *$4* (string): Bitwarden client secret ... when running on localhost pass a data from anywhere, when running in a Github Actions workflow pass the correct Actions secret - _Mandatory for ``plan`` and ``apply``_
# * *$5* (string): Bitwarden master password ... when running on localhost pass a data from anywhere, when running in a Github Actions workflow pass the correct Actions secret - _Mandatory for ``plan`` and ``apply``_
#
# === Script Example
#
# To run this script locally, run the commands in the same order as the pipeline does (see docs for
# each function). Running this script without arguments will result in an error.
#
# [source, bash]
# ```
# ./apply-config.sh init
# ./apply-config.sh lint
# ./apply-config.sh validate
# ./apply-config.sh fmt
# ./apply-config.sh plan "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
# ./apply-config.sh apply "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
# ./apply-config.sh docs
# ./apply-config.sh cleanup
# ```


# Avoid 'unbound variable' errors in pipeline
readonly LOG_ERROR="[\e[1;31mERROR\e[0m]"
readonly LOG_INFO="[\e[34mINFO\e[0m]"

readonly OPTION_APPLY="apply"
readonly OPTION_DOCS="docs"
readonly OPTION_CLEANUP="cleanup"
readonly OPTION_FORMAT="fmt"
readonly OPTION_INITIALIZE="init"
readonly OPTION_LINT="lint"
readonly OPTION_PLAN="plan"
readonly OPTION_VALIDATE="validate"
readonly OPTION_VERSION="-version"

readonly TF_PLAN_FILE="tfplan"
readonly TF_STATE_FILE="terraform.tfstate"
readonly DATA_REPO_PATH="/tmp/repos"
readonly DATA_REPO_NAME="configs-persistent-data"


TF_COMMAND="$1"
if [ -z "$TF_COMMAND" ]; then
  echo -e "$LOG_ERROR Param missing: Terraform command"
  echo -e "$LOG_ERROR Available arguments are:"
  cat assets/help.adoc
  echo -e "$LOG_ERROR exit" && exit 8
fi
readonly TF_COMMAND


if [ "$TF_COMMAND" = "$OPTION_PLAN" ] || [ "$TF_COMMAND" = "$OPTION_APPLY" ]; then

  TOKEN="$2"
  if [ -z "$TOKEN" ]; then
    echo -e "$LOG_ERROR Param missing: Github Token"
    echo -e "$LOG_ERROR exit" && exit 8
  fi
  readonly TOKEN


  BW_CLIENT_ID="$3"
  if [ -z "$BW_CLIENT_ID" ]; then
    echo -e "$LOG_ERROR Param missing: Bitwarden client id"
    echo -e "$LOG_ERROR exit" && exit 8
  fi
  readonly BW_CLIENT_ID


  BW_CLIENT_SECRET="$4"
  if [ -z "$BW_CLIENT_SECRET" ]; then
    echo -e "$LOG_ERROR Param missing: Bitwarden client secret"
    echo -e "$LOG_ERROR exit" && exit 8
  fi
  readonly BW_CLIENT_SECRET


  BW_MASTER_PASS="$5"
  if [ -z "$BW_MASTER_PASS" ]; then
    echo -e "$LOG_ERROR Param missing: Bitwarden client master pass"
    echo -e "$LOG_ERROR exit" && exit 8
  fi
  readonly BW_MASTER_PASS

fi


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


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

  local DOCKER_IMAGE="sommerfeldio/terraform:0.1.0"
  
  if [ "$TF_COMMAND" = "$OPTION_PLAN" ] || [ "$TF_COMMAND" = "$OPTION_APPLY" ]; then
    docker run --rm \
      --volume /etc/passwd:/etc/passwd:ro \
      --volume /etc/group:/etc/group:ro \
      --user "$(id -u):$(id -g)" \
      --volume /etc/timezone:/etc/timezone:ro \
      --volume /etc/localtime:/etc/localtime:ro \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      --env "GITHUB_TOKEN=$TOKEN" \
      --env "TF_VAR_bw_client_id=$BW_CLIENT_ID" \
      --env "TF_VAR_bw_client_secret=$BW_CLIENT_SECRET" \
      --env "TF_VAR_bw_password=$BW_MASTER_PASS" \
      "$DOCKER_IMAGE" "$@"
  else
    docker run --rm \
      --volume /etc/passwd:/etc/passwd:ro \
      --volume /etc/group:/etc/group:ro \
      --user "$(id -u):$(id -g)" \
      --volume /etc/timezone:/etc/timezone:ro \
      --volume /etc/localtime:/etc/localtime:ro \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      "$DOCKER_IMAGE" "$@"
  fi
}


# @description Apply this configuration by running ``terraform apply -auto-approve``. After
# applying the configuration the ``terraform.state`` file is copied back to the local clone of the
# link:https://github.com/sebastian-sommerfeld-io/configs-persistent-data[configs-persistent-data]
# repository. This updated is committed and pushed back to the remote repository.
#
# Pipeline Step 7.
#
# @example
#    apply
function apply() {
  terraform apply -auto-approve "$TF_PLAN_FILE"
  rm "$TF_PLAN_FILE"

  cp "$TF_STATE_FILE" "$DATA_REPO_PATH/$DATA_REPO_NAME/configs/github/$TF_STATE_FILE"

  (
    cd "$DATA_REPO_PATH/$DATA_REPO_NAME" || exit
    git add "configs/github/$TF_STATE_FILE"
    git commit -m "[Actions Bot] auto-updated terraform state"
    git push
  )
}


# @description Remove all temporary files. When running in a pipeline, this step is always invoked.
#
# Pipeline Step 9.
#
# @example
#    apply
function cleanup() {
  rm -rf .terraform
  rm -f .terraform.lock*
  rm -f "$TF_STATE_FILE"*
  rm -rf "$DATA_REPO_PATH"
  rm -rf .bitwarden
}

# @description Generate documentation about this terraform configuratio by running 
# link:https://github.com/terraform-docs/terraform-docs[terraform-docs] inside a Docker container.
# The generated docs are stored as an Antora partials file.
#
# Pipeline Step 8.
#
# @example
#    validate
function docs() {
  local PARTIALS_DIR="../../../docs/modules/ROOT/partials/GENERATED/github/config"
  local ADOC_FILE="terraform-docs.adoc"

  docker run --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    quay.io/terraform-docs/terraform-docs:0.16.0 asciidoc "$(pwd)" > "$PARTIALS_DIR/$ADOC_FILE"

  old='header,autowidth'
  new='header'
  sed -i "s|$old|$new|g" "$PARTIALS_DIR/$ADOC_FILE"

  old='== '
  new='=== '
  sed -i "s|$old|$new|g" "$PARTIALS_DIR/$ADOC_FILE"

  old='a,a,a,a,a'
  new='a,3a,a,a,a'
  sed -i "s|$old|$new|g" "$PARTIALS_DIR/$ADOC_FILE"
}


# @description Apply consistent format to all .tf files by running ``terraform fmt -recursive``.
#
# Pipeline Step 5.
#
# @example
#    fmt
function format() {
  terraform fmt -recursive
}


# @description Initialize this configuration by running ``terraform init``. Before running
# ``terraform init`` the link:https://github.com/sebastian-sommerfeld-io/configs-persistent-data[configs-persistent-data]
# repo is cloned and the terraform state is copied to its correct location. This is done to
# use terraform as it is intended. Without a state, terraform assumes that every config must
# be applied (which mostly is not necessary). Terraform sould only apply the settings that
# don't match the defintion.
#
# Pipeline Step 2.
#
# @example
#    initialize
function initialize() {
  mkdir -p "$DATA_REPO_PATH"

  (
    cd "$DATA_REPO_PATH" || exit
    git clone "git@github.com:sebastian-sommerfeld-io/$DATA_REPO_NAME.git"
  )

  terraform init

  cp "$DATA_REPO_PATH/$DATA_REPO_NAME/configs/github/$TF_STATE_FILE" "$TF_STATE_FILE"
}


# @description Use link:https://github.com/terraform-linters/tflint[terraform-linters/tflint] linter
# to check terraform config (specifically
# link:https://github.com/terraform-linters/tflint-bundle[terraform-linters/tflint-bundle]).
#
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
#
# Pipeline Step 6.
#
# @example
#    plan
function plan() {
  terraform plan -out="$TF_PLAN_FILE"
}


# @description Validate Terraform configuration by running ``terraform validate``.
#
# Pipeline Step 4.
#
# @example
#    validate
function validate() {
  terraform validate
}


# @description Show Terraform version by running ``terraform -version``.
#
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
  "$OPTION_CLEANUP" ) cleanup ;;
  "$OPTION_DOCS" ) docs ;;
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
