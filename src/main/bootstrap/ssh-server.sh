#!/bin/bash
# @file bootstrap-ssh-server.sh
# @brief Run basic provisioning.
#
# @description This script installs and configures openssh-server.
#
# ==== Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


LOG_DONE="[\e[32mDONE\e[0m]"
# LOG_ERROR="[\e[1;31mERROR\e[0m]"
LOG_INFO="[\e[34mINFO\e[0m]"
# LOG_WARN="[\e[93mWARN\e[0m]"
Y="\e[93m"
P="\e[35m"
D="\e[0m"


echo -e "$LOG_INFO +---------------------------------------------------+"
echo -e "$LOG_INFO |    Install and configure openssh-server           |"
echo -e "$LOG_INFO |    to allow further setup using Ansible.          |"
echo -e "$LOG_INFO +---------------------------------------------------+"
echo -e "$LOG_INFO Running on host ${P}$HOSTNAME${D}"


echo -e "$LOG_INFO ${Y}Update apt cache${D}"
sudo apt-get -y update

echo -e "$LOG_INFO ${Y}Install openssh-server${D}"
echo -e "$LOG_INFO Install and start SSH server"
sudo apt-get -y update
sudo apt-get install -y openssh-server
sudo ufw allow ssh # if the firewall is enabled on your system, open the ssh port
sudo systemctl enable --now ssh
echo -e "$LOG_DONE Installed and started SSH server"
