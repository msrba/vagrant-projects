#!/bin/bash

locale-gen de_DE.utf8

# Fix kernel to last known working combination with openvswitch
#apt-mark hold linux-image-3.8.0-32-generic
#apt-get -y purge linux-image-$(uname -r)
#apt-get -y install linux-image-3.8.0-32-generic
#apt-get -y install linux-headers-3.8.0-32-generic

# Update distro
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade

# Downgrade / ping facter to 1.7.x to fix following error message:
# Could not evaluate: Could not retrieve information from environment cloud source(s) puppet://puppetmaster.cloud.gwdg.de/pluginfacts
apt-get -y --force-yes install facter=1.7.5-1puppetlabs1
apt-mark hold facter

# Some fancy stuff
cp /vagrant/scripts/files/.vimrc /root/

# Setup hosts file
cp -av /etc/hosts /etc/hosts.orig

HOSTNAME="$(hostname).cloud.gwdg.de"
HOST_IP=$(cat /vagrant/scripts/files/hosts | grep $(hostname) | cut -d' ' -f1)

cat /etc/hosts.orig | grep -v $HOSTNAME > /etc/hosts
echo "$HOST_IP $HOSTNAME $(hostname)" >> /etc/hosts

cat /vagrant/scripts/files/hosts | grep -v $HOSTNAME >> /etc/hosts

# Adapt puppet.conf 

ENVIRONMENT_NAME='projects'

cat >> /etc/puppet/puppet.conf << EOF
[agent]
server              = puppetmaster.cloud.gwdg.de
environment         = $ENVIRONMENT_NAME

ignorecache         = true
usecacheonfailure   = false
EOF

# Wait for cert
puppet agent -vt --noop --graph --debug --waitforcert 3