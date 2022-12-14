#!/bin/bash
# @file mvn.sh
# @brief Wrapper to use Maven from Docker container when using the default ``mvn`` command.
#
# @description The script is a wrapper to use Maven from a Docker container when using the default
# ``mvn`` command. The script delegates the Maven commands to a container using image
# link:https://hub.docker.com/_/maven[maven].
#
# In order to use the ``mvn`` command the symlink ``/usr/bin/mvn`` is added.
#
# The maven installation from inside the container shares its repository with the host. The maven home directory is
# located at ``$HOME/.m2`` on the Docker host.
#
# NOTE: This script is picked up by the ansible-playbook used to provision the ``caprica`` server node. This way all
# systems share the same setup and versions.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original maven arguments (e.g. ``clean install``)
#
# === Script Example
#
# [source, bash]
# ```
# mvn clean package
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="maven"
readonly TAG="3.8.4-openjdk-17"

docker run -it --rm \
  --volume "$HOME/.m2:/root/.m2" \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" mvn "$@"
