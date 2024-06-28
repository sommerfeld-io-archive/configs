#!/bin/bash
# @file setup.sh
# @brief Setup Retro Pie.
#
# @description This Bash script  is intended to setup Retro Pie inside a Virtual Machine. The VM
# runs on top of Ubuntu 24.10. The script installs Retro Pi and all required dependencies.
#
# Yun can invoke the script directly from GitHub by running the following command:
#
# [source, bash]
# ```
# curl https://raw.githubusercontent.com/sebastian-sommerfeld-io/configs/components/virtual-machines/retro-pie/setup.sh | bash -
# ```
#
# === Manual Todos
#
# * Install a virtual machine with Ubuntu.
# * Install Virtual Box Guest Additions
# * The script does not install any games. You need to download the games (ROMs) manually and place in ``~/RetroPie/roms``.
#
# === VM Requirements
#
# This script has been tested with Ubuntu 24.10. The VM is set up with 8 GB RAM and 4 CPUs which
# equals the RAM and CPUs of a Raspberry Pi 4. The HDD is set up with 32 GB.
#
# The VM was not installed with Vagrant or Ansible. Ubuntu was downloaded from the official
# website and installed manually.
#
# === Script Arguments
#
# The script does not accept any parameters.
#
# === See
#
# See https://retropie.org.uk/docs/Debian for instructions on building the RetroPie setup on Ubuntu
# (18.04 LTS or later) x86 and Debian based distros.
#
# * https://retropie.org.uk
# * https://retropie.org.uk/docs


readonly REPO="RetroPie-Setup"

(
    cd "$HOME" || exit

    echo "[INFO] Install packages"
    sudo apt update && sudo apt upgrade
    sudo apt install -y git dialog unzip xmlstarlet

    echo "[INFO] Clone $REPO repository"
    git clone --depth=1 "https://github.com/RetroPie/$REPO.git"

    cd "$REPO" || exit

    echo "[INFO] Install RetroPie"
    sudo ./retropie_setup.sh
)
