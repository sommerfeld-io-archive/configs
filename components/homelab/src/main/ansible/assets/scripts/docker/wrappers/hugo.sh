#!/bin/bash
## The script is a wrapper to use hugo from a Docker container when using the default
## `hugo` command. The script delegates the hugo commands to a container using image
## link:https://hub.docker.com/r/klakegg/hugo[klakegg/hugo].
##
## In order to use the `hugo` command the symlink `/usr/bin/hugo` is added.
##
## CAUTION: To update scripts, adjust files at `~/work/repos/sebastian-sommerfeld-io/configs/components/homelab/src/main/ansible/assets/scripts/docker/wrappers` and run ansible playbook.
##
## === Script Arguments
## * *$@* (array): Original arguments (e.g. `clean install`)


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


readonly IMAGE="klakegg/hugo"
readonly TAG="asciidoctor"

docker run -it --rm -p 7313:1313 \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"
