#!/bin/bash
# @file ansible-cli.sh
# @brief Command line interface to run Ansible playbooks.
#
# @description This Bash script allows the installation and uninstallation of Ansible Galaxy
# modules and running Ansible playbooks. The script is designed to simplify the management of
# Ansible modules and playbooks
#
# The script uses a Docker container to run Ansible, ensuring that your system remains clean and
# free from dependencies. The Docker container is pre-configured with Ansible and all required
# dependencies. 
#
# In addition to module installation and uninstallation, the main purpose ot this script is to run
# Ansible playbooks within the Docker container. 
#
# To run playbooks successfully, make sure to run ``ssh-copy-id <REMOTE_USER>@<REMOTE_SERVER>.fritz.box``
# first to ensure seamless connects to all remote machines.
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
# Overall, this script is designed to simplify the management of Ansible modules and playbooks by
# providing a clean and automated environment for running them.
#
# === Prerequisites
#
# Before using this script, you need to ensure that Docker and Docker Compose is installed on the
# system. The script assumes that the Docker engine is running, and the user has necessary
# permissions to execute Docker commands.
#
# === Ansible Playbook
#
# ==== Ansible Playbook: desktops.yml
#
# This Ansible playbook is designed to configure basic settings, directory structure, and software
# packages for Ubuntu desktop machines. The playbook also includes some tasks that are shared with
# other playbooks to ensure a consistent setup among all machines.
#
# ==== Ansible Playbook: raspi.yml
#
# This Ansible playbook is designed to configure basic settings, directory structure, and software
# packages for Raspberry Pi machines. The playbook also includes some tasks that are shared with
# other playbooks to ensure a consistent setup among all machines but uses a reduced tasks set.
#
# ==== Ansible Playbook: steam.yml
#
# This Ansible playbook is designed to install Steam on Ubuntu desktop machines.
#
# ==== Ansible Playbook: update-upgrade.yml
#
# This Ansible playbook is designed to update all packages to their latest version and perform an
# aptitude safe-upgrade on Ubuntu and RaspberryPi OS machines (both are Debian-based).
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly SELECT_OPTION_INSTALL="install_dependencies"
readonly SELECT_OPTION_UNINSTALL="uninstall_dependencies"
readonly SELECT_OPTION_PLAYBOOK="run_playbook"
readonly MANDATORY_USER="sebastian"


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

  docker run -it --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
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
      echo -e "$LOG_WARN Todo ..."
      # ansible-galaxy install gantsign.visual-studio-code-extensions
    ;;
    "$SELECT_OPTION_UNINSTALL" )
      echo -e "$LOG_INFO Uninstall ansible-galaxy modules"
      echo -e "$LOG_WARN Todo ..."
      # ansible-galaxy remove gantsign.visual-studio-code-extensions
    ;;
  esac

  break
done
