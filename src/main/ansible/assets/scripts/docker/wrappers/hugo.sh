#!/bin/bash
# @file hugo.sh
# @brief Wrapper to use hugo from Docker container when using the default ``hugo`` command.
#
# @description The script is a wrapper to use hugo from a Docker container when using the default ``hugo`` command.
# The script delegates the hugo commands to a container using image ``link:https://hub.docker.com/r/klakegg/hugo[klakegg/hugo]``.
#
# In order to use the ``hugo`` command, the ``11-configure-wrappers.sh`` script adds a symlink to access this script via
# ``/usr/bin/hugo``.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# ==== Arguments
#
# * *$@* (array): Original arguments (e.g. ``clean install``)


IMAGE="klakegg/hugo"
TAG="asciidoctor"

docker run -it --rm -p 7313:1313 \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"
