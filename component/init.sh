#!/bin/bash

# Read versions
. /opt/legodev/versions.sh
# Read ports
. /opt/legodev/ports.sh

# Install systemd
apt install -y systemd systemd-sysv

# Remove unnecessary systemd config files (see https://github.com/j8r/dockerfiles/blob/master/systemd/debian/10.Dockerfile)
rm -f /lib/systemd/system/multi-user.target.wants/* \
  /etc/systemd/system/*.wants/* \
  /lib/systemd/system/local-fs.target.wants/* \
  /lib/systemd/system/sockets.target.wants/*udev* \
  /lib/systemd/system/sockets.target.wants/*initctl* \
  /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
  /lib/systemd/system/systemd-update-utmp*

# Add the backports repository
echo 'deb http://deb.debian.org/debian buster-backports main' >/etc/apt/sources.list.d/backports.list
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null

# Upgrade the system
apt update
apt upgrade -y

packages=(
  sudo
  vim
  nano
  curl
  dialog
  git
  unzip
  ncdu
  git-lfs
  wget
  openssl
  screen
)

# Download all common packages
apt install -y "${packages[@]}"
