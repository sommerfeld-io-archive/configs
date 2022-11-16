#!/bin/bash
# @file ansible-cli.sh
# @brief Command line interface to run Ansible playbooks.
#
# @description This script allows installation / uninstallation of ansible galaxy modules (see script for
# for modules list) and running Ansible playbooks. Ansible runs in a Docker container.
#
# To run playbooks successfully, make sure to run ``ssh-copy-id <REMOTE_USER>@<REMOTE_SERVER>.fritz.box``
# first ensure seamless connects to all remote machines.
#
# [source, bash]
# ```
# ssh-copy-id sebastian@caprica.fritz.box
# ssh-copy-id sebastian@kobol.fritz.box
# ssh-copy-id pi@prometheus.fritz.box
# ```
#
# NOTE: Ansible expects the user ``sebastian`` to be present on all nodes. This user is the default
# user for each node (workstation and RasPi). Normally this user is created from the setup wizard.
# This scripts exits with ``exitcode=8`` if this user does not exist.
#
# === Script Arguments
#
# The script does not accept any parameters.


SELECT_OPTION_INSTALL="install_dependencies"
SELECT_OPTION_UNINSTALL="uninstall_dependencies"
SELECT_OPTION_PLAYBOOK="run_playbook"
MANDATORY_USER="sebastian"

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# @description Wrapper function to encapsulate ansible in a docker container using the 
# link:https://hub.docker.com/r/cytopia/ansible[cytopia/ansible] image.
#
# Ansible runs in Docker as non-root user (the current user from the host is used inside the container).
# Filesystem dependencies are mounted into the container to ensure the user inside the container shares
# all relevant information with the user from the host.
#
# The current working directory is mounted into the container and selected as working directory so that
# all file of the project are available. Paths are preserved.
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

  # docker run -it --rm \
  #   --volume "$HOME/.ansible:/root/.ansible:rw" \
  #   --volume "$HOME/.ssh:/root/.ssh:ro" \
  #   --volume /etc/timezone:/etc/timezone:ro \
  #   --volume /etc/localtime:/etc/localtime:ro \
  #   --volume "$(pwd):$(pwd)" \
  #   --workdir "$(pwd)" \
  #   --network host \
  #   cytopia/ansible:latest-tools "$@"
  docker run -it --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u)" \
    --volume "$HOME/.ansible:$HOME/.ansible:rw" \
    --volume "$HOME/.ssh:$HOME/.ssh:ro" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    --network host \
    cytopia/ansible:latest-tools "$@"
}


# @description Facade to map ``ansible`` command. The actual Ansible execution is delegated to
# Ansible running in a Docker container.
#
# @example
#    echo "test: $(ansible --version)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible() {
  invoke ansible "$@"
}


# @description Facade to map ``ansible-playbook`` command. The actual Ansible execution is delegated to
# Ansible running in a Docker container.
#
# @example
#    echo "test: $(ansible-playbook playbook.yml)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible-playbook() {
  invoke ansible-playbook "$@"
}


# @description Facade to map ``ansible-galaxy`` command. The actual Ansible execution is delegated to
# Ansible running in a Docker container.
#
# @example
#    echo "test: $(ansible-galaxy install <extension>)"
#
# @arg $@ String The ansible-galaxy commands (1-n arguments) - $1 is mandatory
function ansible-galaxy() {
  invoke ansible-galaxy "$@"
}


docker run --rm mwendler/figlet:latest 'Ansible CLI'
echo -e "$LOG_INFO What should I do?"
select task in "$SELECT_OPTION_PLAYBOOK" "$SELECT_OPTION_INSTALL" "$SELECT_OPTION_UNINSTALL"; do
  case "$task" in
    "$SELECT_OPTION_PLAYBOOK" )
      (
        cd ansible || exit

        if ! id "$MANDATORY_USER" &>/dev/null; then
          echo -e "$LOG_ERROR +-----------------------------------------------------------------------------+"
          echo -e "$LOG_ERROR |    MANDATORY USER NOT FOUND !!!                                             |"
          echo -e "$LOG_ERROR |                                                                             |"
          echo -e "$LOG_ERROR |    Ansible expects the user ${P}sebastian${D} to be present on all nodes.           |"
          echo -e "$LOG_ERROR |    This user is the default user for each node (workstation and RasPi).     |"
          echo -e "$LOG_ERROR |    Normally this user is created from the setup wizard.                     |"
          echo -e "$LOG_ERROR +-----------------------------------------------------------------------------+"
          echo -e "$LOG_ERROR exit" && exit 8
        fi


        echo -e "$LOG_INFO Select playbook"
        #select s in $(cd playbooks && ls | grep .yml | grep -v playbook); do
        select playbook in playbooks/*.yml; do
          echo -e "$LOG_INFO Run $P$playbook$D"
          ansible-playbook "$playbook" --inventory hosts.yml --ask-become-pass

          break
        done
      )
    ;;
    "$SELECT_OPTION_INSTALL" )
      echo -e "$LOG_INFO Install ansible-galaxy modules"
      # ansible-galaxy install gantsign.visual-studio-code-extensions
    ;;
    "$SELECT_OPTION_UNINSTALL" )
      echo -e "$LOG_INFO Uninstall ansible-galaxy modules"
      # ansible-galaxy remove gantsign.visual-studio-code-extensions
    ;;
  esac

  break
done
