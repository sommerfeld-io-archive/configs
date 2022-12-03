#!/bin/bash
# @file run-tests.sh
# @brief Run Inspec tests against several machines.
#
# @description This script run link:https://docs.chef.io/inspec[Chef Inspec] tests against several
# machines.
#
# Chef InSpec is an open-source framework for testing and auditing your applications and infrastructure.
# Chef InSpec works by comparing the actual state of your system with the desired state that you express
# in easy-to-read and easy-to-write Chef InSpec code. Chef InSpec detects violations and displays findings
# in the form of a report, but puts you in control of remediation.
#
# Inspec runs inside a Docker container with a non-root user. The target machines are parsed from the
# Ansible inventory file (src/main/ansible/hosts.yml).
#
# IMPORTANT: This script is *not* intended for use "from anywhere". It is designed to work on my local
# workstations and depend on (1) all nodes up-and running, (2) network connectivity to the respective
# node and (3) correct SSH keys to connect to the respective node.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === Script Example
#
# [source, bash]
# ```
# ./run-tests.sh
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


ANSIBLE_INVENTORY="src/main/ansible/hosts.yml"
ANSIBLE_GROUP="x86_ubuntu_desktop"


# @description Wrapper function to encapsulate ``inspec`` in a docker container using the
# link:https://hub.docker.com/r/chef/inspec[chef/inspec] image.
#
# The container does not run as root. Filesystem dependencies are mounted into the container to ensure
# the user inside the container shares all relevant information with the user from the host.
#
# The current directory is mounted into the container and selected as working directory so that all
# files of the project are available. Paths are preserved.
#
# @example
#    inspec --version
#
# @arg $@ String The command arguments (1-n arguments) - $1 is mandatory
#
## @exitcode 8 If param with command arguments is missing
function inspec() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command arguments passed to the container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi


  docker run -it --rm \
    --volume /etc/passwd:/etc/passwd:ro \
    --volume /etc/group:/etc/group:ro \
    --user "$(id -u):$(id -g)" \
    --volume "$HOME/.ssh:$HOME/.ssh:ro" \
    --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    chef/inspec:latest "$@" --chef-license=accept
}


docker run --rm mwendler/figlet:latest 'Run Inspec Tests'
echo -e "$LOG_INFO ========== Test Environment ============================================="
echo "Inspec version"
inspec --version
echo -e "$LOG_INFO ========================================================================="


# echo -e "$LOG_INFO Create new inspec profile $P$ANSIBLE_GROUP$D"
# inspec init profile "$ANSIBLE_GROUP"2

echo -e "$LOG_INFO Validate inspec profile $P$ANSIBLE_GROUP$D"
inspec check "$ANSIBLE_GROUP"

(
  echo -e "$LOG_INFO Read hostnames for group '$ANSIBLE_GROUP' from Ansible inventory"
  cd ../../../ || exit

  HOSTS=$(docker run --rm \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    mikefarah/yq:latest eval ".all.children.$ANSIBLE_GROUP.hosts" "$ANSIBLE_INVENTORY")

  (
    echo -e "$LOG_INFO Run Inspec profiles for all node from group '$ANSIBLE_GROUP'"
    cd src/test/inspec || exit

    for h in $HOSTS; do
      host=${h%":"}

      echo -e "$LOG_INFO Run inspec profile $P$ANSIBLE_GROUP$D on host $P$host$D"
      inspec exec "$ANSIBLE_GROUP" --target=ssh://"$USER@$host" --key-files="$HOME/.ssh/id_rsa"
    done
  )
)
