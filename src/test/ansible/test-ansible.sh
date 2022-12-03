#!/bin/bash
# @file test-ansible.sh
# @brief Test Ansible playbooks and tasks.
#
# @description This script vaidates and tests Ansible playbooks and tasks. It acts as a local development
# script before adding the tests to the CI pipeline.
#
# This script uses link:https://molecule.readthedocs.io/en/latest/index.html[Molecule] to test Ansible.
# Molecule is built into a Docker image by the link:https://github.com/ansible/creator-ee[Ansible Creator Execution Environment]
# project. The Ansible Creator Execution Environment is a container (execution environment) aimed towards
# being used for the development and testing of the Ansible content. We should also mention that this
# container must not be used in production by Ansible users. It includes:
#
# * link:https://github.com/ansible/ansible[ansible-core]
# * link:https://github.com/ansible/ansible-lint[ansible-lint]
# * link:https://github.com/ansible-community/molecule[molecule]
#
# [CAUTION]
# TODO This script is still work in progress ... see https://sommerfeld-io.atlassian.net/browse/SIO-221
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./test-ansible.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace




# @description Wrapper function to encapsulate ``molecule`` and ``ansible-lint`` in a docker container
# using the link:https://quay.io/repository/ansible/creator-ee[quay.io/ansible/creator-ee] image (for 
# additional info see link:https://github.com/ansible/creator-ee[ ansible/creator-ee] on Github).
#
# // Ansible runs in Docker as non-root user (the current user from the host is used inside the container).
#
# Filesystem dependencies are mounted into the container to ensure the user inside the container shares
# all relevant information with the user from the host.
#
# The current working directory is mounted into the container and selected as working directory so that
# all file of the project are available. Paths are preserved.
#
# @example
#    invoke molecule --version
#
# @arg $@ String The actual command (1-n arguments) - $1 is mandatory
#
## @exitcode 8 If param with command arguments is missing
function invoke() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

#   docker run --rm \
#     --volume /etc/passwd:/etc/passwd:ro \
#     --volume /etc/group:/etc/group:ro \
#     --user "$(id -u)" \
#     --volume "$(pwd):$(pwd)" \
#     --workdir "$(pwd)" \
#     quay.io/ansible/creator-ee:latest "$@"
  docker run -it --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    quay.io/ansible/creator-ee:latest "$@"
}


# @description Facade to map ``molecule`` command. The actual execution is delegated
# to a Docker container.
#
# @example
#    molecule --version
#
# @arg $@ String The molecule commands (1-n arguments) - $1 is mandatory
function molecule() {
  invoke molecule "$@"
}


# @description Facade to map ``ansible-lint`` command. The actual execution is delegated
# to a Docker container.
#
# @example
#    ansible-lint --version
#
# @arg $@ String The molecule commands (1-n arguments) - $1 is mandatory
function ansible-lint() {
  invoke ansible-lint "$@"
}


echo -e "$LOG_INFO ========== Test Environment ============================================="
molecule --version
ansible-lint --version
echo -e "$LOG_INFO ========================================================================="

(
  echo -e "$LOG_INFO Lint Ansible files"
  cd ../../main/ansible || exit

  ansible-lint -p playbooks/main.yml
)
