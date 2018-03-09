#!/bin/bash -e

echo "================= Installing NVM ==================="
curl -sS https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash

# Set NVM_DIR so the installations go to the right place
export NVM_DIR="/root/.nvm"

# add source of nvm to .bashrc - allows user to use nvm as a command
echo "source ~/.nvm/nvm.sh" >> /etc/drydock/.env

echo "================= Installing nodejs 7.10.1 ================="
curl -sSL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -qq -y nodejs=9.8.0*

echo "================= Installing latest yarn ==================="
sudo apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg
echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update -qq
sudo apt-get install -qq -qq -y yarn=1.5.1*
