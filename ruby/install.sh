#!/bin/bash -e

#adding keys
cd /root
# added to fix https://github.com/rvm/rvm/issues/3108
curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -

echo "================= Installing RVM ==================="
curl -sSL https://get.rvm.io | bash -s stable

# Set source to rvm
echo "source /usr/local/rvm/scripts/rvm" >> /etc/drydock/.env
source /usr/local/rvm/scripts/rvm
rvm requirements

export RVM_VERSION=2.6.0
echo "================= Installing default ruby ==================="
rvm install "$RVM_VERSION"

# tell rvm to use this version as default
rvm use "$RVM_VERSION" --default

#update gems to current
rvm rubygems current
