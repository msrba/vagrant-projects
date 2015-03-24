#!/bin/bash

locale-gen de_DE.utf8

# Update distro
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade

# Downgrade / ping facter to 1.7.x to fix following error message:
# Could not evaluate: Could not retrieve information from environment cloud source(s) puppet://puppetmaster.cloud.gwdg.de/pluginfacts
apt-get -y --force-yes install facter=1.7.5-1puppetlabs1
apt-mark hold facter

# Some fancy stuff
cp /vagrant/files/.vimrc /root/

# Setup hosts file
cp -av /etc/hosts /etc/hosts.orig

HOSTNAME="$(hostname).cloud.gwdg.de"
HOST_IP=$(cat /vagrant/files/hosts | grep $(hostname) | cut -d' ' -f1)

cat /etc/hosts.orig | grep -v $HOSTNAME > /etc/hosts
echo "$HOST_IP $HOSTNAME $(hostname)" >> /etc/hosts