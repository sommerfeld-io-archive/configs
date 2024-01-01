#!/bin/bash
# @file lint-ansible.sh
# @brief Lorem ipsum dolor sit amet, consetetur sadipscing elitr.
#
# @description Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut
# labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
# Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
#
# === Script Arguments
#
# The script does not accept any parameters.
# * *$1* (string): Some var
#
# === Script Example
#
# [source, bash]
# ```
# ./lint-ansible.sh
# ```
#
# == Prerequisites
#
# Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore
# magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd
# gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
#
# == Lorem ipsum dolor
#
# Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore
# magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd
# gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly PLAYBOOK_BASE_PATH="components/homelab/src/main/ansible/playbooks"


echo "[INFO] run ansible-lint in docker container"
echo "[INFO] triggered by $0"

(
    cd ../../../../ || exit
    docker run --rm \
        --volume "$(pwd):$(pwd)" \
        --workdir "$(pwd)" \
        cytopia/ansible-lint:latest "$PLAYBOOK_BASE_PATH/"*.yml  -c "$(pwd)/.ansible-lint.yml"
)
