#!/bin/bash
# @file python.sh
# @brief Wrapper to use Python from Docker container when using the ``py`` command.
#
# @description The script is a wrapper to use Python from a Docker container when using the ``py`` command. The script
# delegates the all tasks to the Python runtime inside a container using image ``link:https://hub.docker.com/_/python[python]``.
#
# image::https://raw.githubusercontent.com/docker-library/docs/01c12653951b2fe592c1f93a13b4e289ada0e3a1/python/logo.png[]
#
# In order to use the ``py`` command, the ``11-configure-wrappers.sh`` script adds a symlink to access this script via
# ``/usr/bin/py``.
#
# CAUTION: Ubuntu ships with Python 3.9 pre-installed and allocates the ``python``, ``python3`` and ``python3.9``
# commands. So don't confuse them with ``py`` which triggers this wrapper.
#
# CAUTION: To update scripts, adjust files at ``~/work/repos/sebastian-sommerfeld-io/configs/src/main/ansible/assets/scripts/docker/wrappers`` and run ansible playbook.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for Python inside Docker"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="python"
TAG="3.9.10"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" python "$@"
