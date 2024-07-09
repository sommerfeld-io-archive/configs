#!/bin/bash
## The script is a wrapper to use yamllint from a Docker container when using the default `yamllint`
## command. The script delegates the all tasks to the yamllint runtime inside a container using image
## link:https://hub.docker.com/r/cytopia/yamllint[cytopia/yamllint].
##
## In order to use the `yamllint` command the symlink `/usr/bin/yamllint` is added.
##
## CAUTION: To update scripts, adjust files at `~/work/repos/sebastian-sommerfeld-io/configs/components/homelab/src/main/ansible/assets/scripts/docker/wrappers` and run ansible playbook.
##
## === Usage
##
## [source, bash]
## ....
## yamllint .
## ....
##
## * *$@* (array): Original arguments


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="cytopia/yamllint"
readonly TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished yamllint"
