#!/bin/bash
# @file build-and-run.sh
# @brief Run Github CLI in a local Docker image.
#
# @description The script runs the link:https://cli.github.com/manual/[Github CLI] inside a local
# docker image. Make sure the image is built first.
#
# === Script Arguments
#
# * *$@* (...): The same parameters as the Github CLI app.
#
# === Script Example
#
# [source, bash]
# ```
# ./run.sh --version
# ```

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

readonly IMAGE="local/github-cli:dev"


docker run --rm "$IMAGE" --version
