#!/bin/bash
# @file hadolint.sh
# @brief Wrapper to use hadolint from Docker container when using the default ``hadolint`` command.
#
# @description The script is a wrapper to use hadolint from a Docker container when using the default ``hadolint``
# command. The script delegates the all tasks to the hadolint runtime inside a container using image
# ``link:https://hub.docker.com/r/hadolint/hadolint[hadolint/hadolint]``.
#
# In order to use the ``hadolint`` command, the ``11-configure-wrappers.sh`` script adds a symlink to
# access this script via ``/usr/bin/hadolint``.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


IMAGE="hadolint/hadolint"
TAG="latest"

docker run -i --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished hadolint"
