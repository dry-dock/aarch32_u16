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

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock
touch /etc/drydock/.env

echo "================= Installing basic packages ==================="
apt-get install -y -q \
  build-essential=12.1ubuntu2* \
  curl=7.47* \
  gcc=4:5.3* \
  gettext=0.19* \
  htop=2.0* \
  libxml2-dev=2.9* \
  libxslt1-dev=1.1* \
  make=4.1* \
  nano=2.5* \
  openssh-client=1:7* \
  openssl=1.0* \
  software-properties-common=0.96* \
  sudo=1.8* \
  texinfo=6.1* \
  unzip=6.0* \
  zip=3.0* \
  wget=1.17* \
  rsync=3.1* \
  psmisc=22.21* \
  libssl-dev=1.0* \
  libffi-dev=3.2* \
  vim=2:7*

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update -qq
apt-get install -y -q git=1:2*

echo "================= Installing Python packages ==================="
apt-get install -y -q \
  python-pip=8.1* \
  python-software-properties=0.96* \
  python-dev=2.7*

pip install virtualenv

echo "================= Adding JQ 1.5.1 ==================="
apt-get install -y -q jq=1.5*

echo "================= Installing Node 8.x ==================="
/u16/node/install.sh

echo "================= Installing Java 10 ==================="
/u16/java/install.sh

echo "================= Installing Ruby 2.5.1  ==================="
/u16/ruby/install.sh

echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk=211.*

KUBECTL_VERSION=1.11.0
echo "================= Adding kubectl $KUBECTL_VERSION ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/arm/kubectl
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/arm/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "================= Adding awscli 1.15.73 ============"
sudo pip install 'awscli==1.15.73'

echo "================= Adding awsebcli 3.14.3 ============"
sudo pip install 'awsebcli==3.14.3'

echo "================= Adding openstack client 3.16.0 ============"
sudo pip install 'python-openstackclient==3.16.0'
sudo pip install 'shade==1.29.0'

echo "================ Adding ansible 2.6.1 ===================="
sudo pip install 'ansible==2.6.1'

echo "================ Adding boto 2.49.0 ======================="
sudo pip install 'boto==2.49.0'

echo "================ Adding boto3 ======================="
sudo pip install 'boto3==1.7.72'

echo "================ Adding apache-libcloud 2.3.0 ======================="
sudo pip install 'apache-libcloud==2.3.0'

echo "================ Adding azure 3.0.0 ======================="
sudo pip install 'azure==3.0.0'

echo "================ Adding dopy 0.3.7a ======================="
sudo pip install 'dopy==0.3.7a'

export PK_VERSION=1.2.5
echo "================ Adding packer $PK_VERSION ===================="
export PK_FILE=packer_"$PK_VERSION"_linux_arm.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ================="
git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/aarch32/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
