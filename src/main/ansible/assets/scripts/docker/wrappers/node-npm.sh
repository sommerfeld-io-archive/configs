#!/bin/bash
# @file yamllint.sh
# @brief Wrapper to use NodeJS from Docker container when using the default ``node`` and ``npm`` commands.
#
# @description The script is a wrapper to use NodeJS from a Docker container when using the default
# ``node`` and ``npm`` commands. The script delegates the all tasks to the yamllint runtime inside a
# container using image link:https://hub.docker.com/r/cytopia/yamllint[cytopia/yamllint].
#
# In order to use the ``node`` and ``npm`` commands the symlinks ``/usr/bin/node`` and 
# ``/usr/bin/npm`` are added.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/ansible/assets/scripts/docker/wrappers``
# and run ansible playbook.
#
# === Script Arguments
#
# * *$0* (string): Current filename (``/usr/bin/node`` or ``/usr/bin/npm``)
# * *$@* (array): Original arguments
#
# === Script Example
#
# [source, bash]
# ```
# node --version
# npm --version
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


IMAGE="node"
TAG="19-bullseye"

# $0 = /usr/bin/node or /ust/bin/npm
# $@ = arguments
cmd="${0##*/}"

echo -e "$LOG_INFO Run: $cmd" "$@"
docker run -it --rm \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --user "$(id -u):$(id -g)" \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$cmd" "$@"
