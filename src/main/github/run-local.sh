#!/bin/bash
# @file run-local.sh
# @brief Wrapper script to apply the Github configuration during development from localhost in an
# easier way.
#
# @description This script is just a wrapper script to apply the Github configuration during
# development from localhost in an easier way. It provides a menu to select the action of choise and
# delegates all commands to `xref:AUTO-GENERATED:bash-docs/src/main/github/apply-config-sh.adoc[apply-config.sh]`.
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


readonly OPTION_CLEAN="clean_local_filesystem"
readonly OPTION_INIT="terraform_init"
readonly OPTION_PLAN="terraform_plan"
readonly OPTION_APPLY="terraform_apply"


echo -e "$LOG_INFO Apply Github configuration"
echo -e "$LOG_INFO ${Y}What do you want me to do?${D}"
select task in "$OPTION_CLEAN" "$OPTION_INIT" "$OPTION_PLAN" "$OPTION_APPLY"; do
  case "$task" in
    "$OPTION_CLEAN" )
        rm -rf .terraform*
        rm -rf terraform*
    ;;
    "$OPTION_INIT" )
        bash ./apply-config.sh init "$TOKEN"
    ;;
    "$OPTION_PLAN" )
        bash ./apply-config.sh lint "$TOKEN"
        bash ./apply-config.sh validate "$TOKEN"
        bash ./apply-config.sh fmt "$TOKEN"
        bash ./apply-config.sh plan "$TOKEN"
    ;;
    "$OPTION_APPLY" )
        bash ./apply-config.sh apply "$TOKEN"
    ;;
  esac

  break
done
