#!/bin/bash
# @file build-and-run.sh
# @brief Run Github CLI in a local Docker image. Build image first if it does not exist.
#
# @description The script builds a Docker image for local use of 
# link:https://cli.github.com/manual/[Github CLI] and runs Github CLI inside a container.
#
# === Script Arguments
#
# * *$@* (...): The same parameters as the Github CLI app.
#
# === Script Example
#
# [source, bash]
# ```
# ./build-and-run.sh --version
# ```

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

readonly IMAGE="local/github-cli:dev"
GH_TOKEN="$(cat .secrets/gh.token)"
readonly GH_TOKEN


# @description Wrapper function to encapsulate link:https://cli.github.com/manual/[Github CLI]
# in a Docker container and make the default ``gh`` command available within this script.
#
# @example
#    gh --version
#
# @arg $@ String The ``gh`` commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with ``gh`` command is missing
function gh() {
  if [ -z "$1" ]; then
    LOG_ERROR "No command passed to the go container"
    LOG_ERROR "exit" && exit 8
  fi

  docker run --rm \
    --env "GITHUB_TOKEN=$GH_TOKEN" \
    "$IMAGE" "$@"
}


# Build image if not existing
if [[ "$(docker images -q "$IMAGE" 2> /dev/null)" == "" ]]; then
  echo -e "$LOG_INFO Build docker image $IMAGE"
  docker build -t "$IMAGE" .
fi

gh "$@"
