#!/bin/bash
# @file shellcheck.sh
# @brief Wrapper to use shellcheck from Docker container when using the default ``shellcheck`` command.
#
# @description The script is a wrapper to use shellcheck from a Docker container when using the default ``shellcheck``
# command. The script delegates the all tasks to the shellcheck runtime inside a container using image
# link:https://hub.docker.com/r/koalaman/shellcheck[koalaman/shellcheck].
#
# In order to use the ``shellcheck`` command the symlink ``/usr/bin/shellcheck`` is added.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/homelab/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original arguments
#
# === Script Example
#
# [source, bash]
# ```
# shellcheck ./*.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="koalaman/shellcheck"
readonly TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished shellcheck"
