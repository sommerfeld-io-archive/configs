#!/bin/bash
# @file build.sh
# @brief Build Docker image for local Github CLI use.
#
# @description The script builds, Docker image to use link:https://cli.github.com/manual/[Github CLI]
# locally.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./build.sh
# ```

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

readonly IMAGE="local/github-cli:dev"


docker build -t "$IMAGE" .
docker run --rm "$IMAGE" --version
