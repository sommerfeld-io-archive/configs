#!/bin/bash
## The script is a wrapper to use Groovy from a Docker container when using the default `groovy` command.
## The script delegates the all tasks to the Groovy runtime inside a container using image
## link:https://hub.docker.com/_/groovy[groovy].
##
## In order to use the `groovy` command the symlink `/usr/bin/groovy` is added.
##
## CAUTION: To update scripts, adjust files at `~/work/repos/sebastian-sommerfeld-io/configs/components/homelab/src/main/ansible/assets/scripts/docker/wrappers` and run ansible playbook.
##
## === Script Arguments
## * *$@* (array): Original arguments


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="groovy"
readonly TAG="4.0.6-jdk17-jammy"

docker run -it --rm \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --user "$(id -u):$(id -g)" \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" groovy "$@"
