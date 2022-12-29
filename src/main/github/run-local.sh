#!/bin/bash
# @file run-local.sh
# @brief Wrapper script to apply Github configuration during development from localhost in an easy way.
#
# @description This script is a wrapper script to apply the Github configuration during development
# from localhost in an easier way. It provides a menu to select the action of choise and delegates
# all commands to `xref:AUTO-GENERATED:bash-docs/src/main/github/apply-config-sh.adoc[apply-config.sh]`
# so there is no need to type the whole commands over and over again. These shortcuts are a much
# simpler way. Additionally it allows `apply-config.sh` to work the same way from localhost and from a
# Github Actions pipeline (both must supply the same params).
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./run-local.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


TOKEN="$(cat .secrets/github.token)"
readonly TOKEN

BW_CLIENT_ID="$(cat .secrets/BW_CLIENT_ID.secret)"
readonly BW_CLIENT_ID
BW_CLIENT_SECRET="$(cat .secrets/BW_CLIENT_SECRET.secret)"
readonly BW_CLIENT_SECRET
BW_MASTER_PASS="$(cat .secrets/BW_MASTER_PASS.secret)"
readonly BW_MASTER_PASS

readonly OPTION_INIT="terraform_init"
readonly OPTION_PLAN="terraform_plan"
readonly OPTION_APPLY="terraform_apply"
readonly OPTION_DOCS="generate_docs"
readonly OPTION_CLEANUP="cleanup"


echo -e "$LOG_INFO Apply Github configuration"
echo -e "$LOG_INFO ${Y}What do you want me to do?${D}"
select task in "$OPTION_INIT" "$OPTION_PLAN" "$OPTION_APPLY" "$OPTION_DOCS" "$OPTION_CLEANUP"; do
  case "$task" in
    "$OPTION_INIT" )
        bash ./apply-config.sh init
    ;;
    "$OPTION_PLAN" )
        bash ./apply-config.sh lint
        bash ./apply-config.sh validate
        bash ./apply-config.sh fmt
        bash ./apply-config.sh plan "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
    ;;
    "$OPTION_APPLY" )
        bash ./apply-config.sh apply "$TOKEN" "$BW_CLIENT_ID" "$BW_CLIENT_SECRET" "$BW_MASTER_PASS"
    ;;
    "$OPTION_DOCS" )
        bash ./apply-config.sh docs
    ;;
    "$OPTION_CLEANUP" )
        bash ./apply-config.sh cleanup
    ;;
  esac

  break
done
