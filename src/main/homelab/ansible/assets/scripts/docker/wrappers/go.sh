#!/bin/bash
# @file Go.sh
# @brief Wrapper to use Go from Docker container when using the default ``go`` command.
#
# @description The script is a wrapper to use Go from a Docker container when using the default ``go``
# command. The script delegates the all tasks to the Go runtime inside a container using the
# link:https://hub.docker.com/_/golang[golang] image.
#
# In order to use the ``go`` command the symlink ``/usr/bin/go`` is added.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/homelab/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original arguments


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="golang"
readonly TAG="1.19-bullseye"

docker run -it --rm \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --user "$(id -u):$(id -g)" \
  --volume "/home/sebastian/.cache:/home/sebastian/.cache" \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" go "$@"
