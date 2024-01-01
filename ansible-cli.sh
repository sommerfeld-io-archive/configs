#!/bin/bash
# @file ansible-cli.sh
# @brief Command line interface to run Ansible playbooks.
#
# @description This Bash script allows to running Ansible playbooks. The script is designed to
# simplify the management of Ansible playbooks.
#
# The script uses a Docker container to run Ansible, ensuring that your system remains clean and
# free from dependencies. The Docker container is pre-configured with Ansible and all required
# dependencies.
#
# To run playbooks successfully, make sure to run ``ssh-copy-id <REMOTE_USER>@<REMOTE_HOST>.fritz.box``
# first to ensure seamless connects to all remote machines. Run ``ssh-copy-id <LOCAL_USER>@<LOCAL_HOST>.fritz.box``
# for your local machine as well (if this machine is listed in the host inventory.). Otherwise Ansible
# might fail when connecting to your local machine via its FQDN.
#
# [source, bash]
# ```
# ssh-copy-id sebastian@caprica.fritz.box
# ssh-copy-id sebastian@kobol.fritz.box
# ```
#
# NOTE: Ansible expects the user ``sebastian`` to be present on all nodes. This user is the default
# user for each node (workstation, server and RasPi). Normally this user is created when installing
# an operating system through its setup wizard. This scripts exits with ``exitcode=8`` if this user
# does not exist.
#
# Overall, this script is designed to simplify the management of Ansible playbooks by providing a
# clean and automated environment for running them.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# == Prerequisites
#
# Before using this script, you need to ensure that Docker 24.0.6 or greater is installed on the
# system which runs the playbooks. The script assumes that the Docker engine is running, and the
# user has necessary permissions to execute Docker commands.
#
# == Ansible Playbooks
#
# This script automatically detects all Ansible playbooks in the ``src/main/homelab/ansible/playbooks``
# folder.
#
# === Ansible Playbook: ``desktops-main.yml``
#
# This Ansible playbook is designed to configure basic settings, directory structure, and software
# packages for Ubuntu desktop machines. The playbook also includes some tasks that are shared with
# other playbooks to ensure a consistent setup among all machines.
#
# === Ansible Playbook: ``desktops-steam.yml``
#
# This Ansible playbook is designed to install Steam on Ubuntu desktop machines.
#
# === Ansible Playbook: ``raspi-main.yml``
#
# This Ansible playbook is designed to configure basic settings, directory structure, and software
# packages for Raspberry Pi machines. The playbook also includes some tasks that are shared with
# other playbooks to ensure a consistent setup among all machines but uses a reduced tasks set.
#
# === Ansible Playbook: ``update-upgrade.yml``
#
# This Ansible playbook is designed to update all packages to their latest version and perform an
# aptitude safe-upgrade on Ubuntu and RaspberryPi OS machines (both are Debian-based).


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly ANSIBLE_USER="sebastian"
readonly TARGET_DIR="target"
readonly INSPEC_TEST_DIR="src/test/homelab/inspec"


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


docker run --rm mwendler/figlet:latest 'Ansible CLI'

(
  cd src/main/homelab/ansible || exit

  if ! id "$ANSIBLE_USER" &>/dev/null; then
    echo -e "$LOG_ERROR +-----------------------------------------------------------------------------+"
    echo -e "$LOG_ERROR |                                                                             |"
    echo -e "$LOG_ERROR |    ANSIBLE USER NOT FOUND !!!                                               |"
    echo -e "$LOG_ERROR |                                                                             |"
    echo -e "$LOG_ERROR |    Ansible expects the user ${P}${ANSIBLE_USER}${D} to be present on all nodes.           |"
    echo -e "$LOG_ERROR |    This user is the default user for each node (workstation and RasPi).     |"
    echo -e "$LOG_ERROR |    Normally this user is created from the setup wizard.                     |"
    echo -e "$LOG_ERROR |                                                                             |"
    echo -e "$LOG_ERROR +-----------------------------------------------------------------------------+"
    echo -e "$LOG_ERROR exit" && exit 8
  fi


  echo -e "$LOG_INFO Select playbook"
  select playbook in playbooks/*.yml; do
    echo -e "$LOG_INFO Run $P$playbook$D"
    ansible-playbook "$playbook" --inventory hosts.yml --ask-become-pass
    break
  done
)

# TODO ... update header docs -> Inspec
# TODO ... wrapper function for inspec in docker container
# TODO ... run tests
# TODO ... at best: dynamically determine the target nodes (only for nodes that are affected by the latest playbook execution)
# TODO ... remove src/test/homelab/inspec/run-tests.sh

docker run --rm mwendler/figlet:latest 'Test'

echo -e "$LOG_INFO Setup target directory"
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR/$INSPEC_TEST_DIR"

(
  echo -e "$LOG_INFO Run Inspec tests -> baseline"
  cd "$TARGET_DIR/$INSPEC_TEST_DIR" || exit

  git clone git@github.com:dev-sec/linux-baseline.git
  git clone git@github.com:dev-sec/cis-docker-benchmark.git

  ls -alF
)

(
  echo -e "$LOG_INFO Run Inspec tests -> homelab"
  cd "$INSPEC_TEST_DIR" || exit

  ls -alF
)
