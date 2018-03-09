#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update
apt-get install -qq locales=2.23*

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u16

echo "================= Updating package lists ==================="
apt-get update

apt-get install -y -q \
  build-essential=12.1ubuntu2* \
  curl=7.47.0* \
  gcc=4:5.3.1* \
  gettext=0.19.7* \
  htop=2.0.1* \
  libxml2-dev=2.9.3+dfsg1* \
  libxslt1-dev=1.1.28* \
  make=4.1* \
  nano=2.5.3* \
  openssh-client=1:7.2p2* \
  openssl=1.0.2g* \
  software-properties-common=0.96.20.7* \
  sudo=1.8.16* \
  texinfo=6.1.0.dfsg.1* \
  unzip=6.0* \
  wget=1.17.1* \
  rsync=3.1.1* \
  psmisc=22.21* \
  vim=2:7.4.1689*

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
