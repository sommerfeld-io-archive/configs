#!/bin/bash
# @file hadolint.sh
# @brief Wrapper to use hadolint from Docker container when using the default ``hadolint`` command.
#
# @description The script is a wrapper to use hadolint from a Docker container when using the default ``hadolint``
# command. The script delegates the all tasks to the hadolint runtime inside a container using image
# link:https://hub.docker.com/r/hadolint/hadolint[hadolint/hadolint].
#
# In order to use the ``hadolint`` command the symlink ``/usr/bin/hadolint`` is added.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/components/homelab/src/main/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# === Script Arguments
#
# * *$@* (array): Original arguments
#
# === Script Example
#
# [source, bash]
# ```
# hadolint < Dockerfile
# hadolint --ignore DL3003 --ignore DL3006 < Dockerfile # exclude specific rules
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="hadolint/hadolint"
readonly TAG="latest"

docker run -i --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished hadolint"
