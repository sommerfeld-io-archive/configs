#!/bin/bash
# @file ansible.sh
# @brief Wrapper to use Ansible from Docker container when using the default ``ansible`` command.
#
# @description The script is a wrapper to use Ansible from a Docker container when using the
# default ``ansible`` command. The script delegates the Ansible commands to a container using
# image link:https://hub.docker.com/r/cytopia/ansible[cytopia/ansible].
#
# In order to use the ``ansible`` command the symlink ``/usr/bin/ansible`` is added.
#
# NOTE: This script is picked up by the ansible-playbook used to provision the ``caprica`` server
# node. This way all systems share the same setup and versions.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/homelab/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original ansible arguments
#
# === Script Example
#
# [source, bash]
# ```
# ansible --version
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="cytopia/ansible"
readonly TAG="latest-tools"

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
  "$IMAGE:$TAG" ansible "$@"
