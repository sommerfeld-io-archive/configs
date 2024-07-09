#!/bin/bash
# @file lint-helm.sh
# @brief Lint Helm charts.
#
# @description This script lints all Helm charts in the repository. It is used as part of the
# pre-commit checks and as part of the pipeline.
#
# === Usage
#
# [source, bash]
# ```
# ./lint-helm.sh
# ```
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

(
    cd ../main/minikube || exit

    for HELM_FOLDER in */; do
        for HELM_CHART_FOLDER in "$HELM_FOLDER"*/; do
            helm lint "$HELM_CHART_FOLDER" --with-subcharts
        done
    done
)
