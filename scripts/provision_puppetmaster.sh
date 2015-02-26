#!/bin/bash

locale-gen de_DE.utf8

# Update distro
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

# Some fancy stuff
cp /vagrant/scripts/files/.vimrc /root/

# Setup hosts file
cp -av /etc/hosts /etc/hosts.orig

HOSTNAME="$(hostname).cloud.gwdg.de"
HOST_IP=$(cat /vagrant/scripts/files/hosts | grep puppetmaster | cut -d' ' -f1)

cat /etc/hosts.orig | grep -v $HOSTNAME > /etc/hosts
echo "$HOST_IP $HOSTNAME $(hostname)" >> /etc/hosts

cat /vagrant/scripts/files/hosts | grep -v $HOSTNAME >> /etc/hosts

# ------------------------------------------------------------------------------------------------
# Setup puppetmaster

MODULE_NAME='projects'
ENVIRONMENT_NAME='projects'

PUPPET_ENVIRONMENT="/etc/puppet/environments/$ENVIRONMENT_NAME"

apt-get -y install puppetmaster

mkdir /var/lib/puppet/state/graphs
chown puppet:puppet /var/lib/puppet/state/graphs

# Configure puppetmaster

# Setup directory environments
echo 'environmentpath = $confdir/environments'      >> /etc/puppet/puppet.conf
echo "environment = $ENVIRONMENT_NAME"              >> /etc/puppet/puppet.conf
echo 'autosign = true'                              >> /etc/puppet/puppet.conf
echo 'storeconfigs = true'                          >> /etc/puppet/puppet.conf

# Disable caching (seems not to work though)
echo 'ignorecache = true'                           >> /etc/puppet/puppet.conf
echo 'usecacheonfailure = false'                    >> /etc/puppet/puppet.conf

# Link puppet modules directly from vagrant directory
mkdir -p $PUPPET_ENVIRONMENT/manifests
ln -s /vagrant/$MODULE_NAME $PUPPET_ENVIRONMENT/modules

# Also link hiera data
ln -s /vagrant/scripts/files/hiera $PUPPET_ENVIRONMENT/hiera

# Fix problems with parameter providers and environments:
rmdir /etc/puppet/modules
ln -s $PUPPET_ENVIRONMENT/modules /etc/puppet/modules

# Remove example environment
rm -Rfv /etc/puppet/environments/example_env

# Setup site.pp
ln -s /vagrant/scripts/files/site.pp $PUPPET_ENVIRONMENT/manifests/

# Setup hiera.yaml
cat /vagrant/scripts/files/hiera/hiera.yaml > /etc/puppet/hiera.yaml

# Restart puppetmaster
service puppetmaster restart

# ------------------------------------------------------------------------------------------------
# Setup puppetdb + apt-cacher-ng (via puppet)

puppet apply /vagrant/scripts/files/puppetmaster.pp  --modulepath /etc/puppet/environments/$ENVIRONMENT_NAME/modules --debug --graph

