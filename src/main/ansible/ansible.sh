#!/bin/bash
# @file ansible.sh
# @brief Run Ansible playbooks.
#
# @description This script runs the Ansible playbooks. Ansible runs in Docker.
#
# Make sure to run ``ssh-copy-id <REMOTE_USER>@<REMOTE_SERVER>.fritz.box`` for all relevant machines.
#
# [source, bash]
# ----
# ssh-copy-id sebastian@caprica.fritz.box
# ssh-copy-id sebastian@kobol.fritz.box
# ssh-copy-id pi@prometheus.fritz.box
# ----
#
# ==== Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# @description Wrapper function to encapsulate link:https://hub.docker.com/r/cytopia/ansible[ansible in a docker container].
# The current working directory is mounted into the container and selected as working directory so that all file are
# available to ansible. Paths are preserved.
#
# @example
#    echo "test: $(invoke ansible --version)"
#
# @arg $@ String The ansible commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with ansible command is missing
function invoke() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the ansible container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

  docker run -it --rm \
    --volume "$HOME/.ssh:/root/.ssh:ro" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --network host \
    cytopia/ansible:latest-tools "$@"
}


# @description Facade to map ``ansible`` command.
#
# @example
#    echo "test: $(ansible --version)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible() {
  invoke ansible "$@"
}


# @description Facade to map ``ansible-playbook`` command.
#
# @example
#    echo "test: $(ansible-playbook playbook.yml)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible-playbook() {
  invoke ansible-playbook "$@"
}

echo -e "$LOG_INFO Lint yaml files"
yamllint .

echo -e "$LOG_INFO Run Ansible playbook"
ansible-playbook playbooks/main.yml --inventory hosts.ini --ask-become-pass
