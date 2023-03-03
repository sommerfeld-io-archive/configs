#!/bin/bash
# @file query-github.sh
# @brief Query data from github and store locally for conky.
#
# @description The script queries information from github and stores them in local files for 
# conky to pick up.
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


./build-and-run.sh --version
./build-and-run.sh repo list --json='name,issues,pullRequests'
