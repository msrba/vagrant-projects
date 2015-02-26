# Puppetmaster provisioning for projects dev environment

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# Setup PuppetDB:
# See https://forge.puppetlabs.com/puppetlabs/puppetdb

class { 'puppetdb':
  database                  => 'postgres',
  listen_address            => 'puppetmaster.cloud.gwdg.de',
  listen_port               => '8080',

  ssl_listen_address        => 'puppetmaster.cloud.gwdg.de',
  ssl_listen_port           => '8081',
}

class { 'puppetdb::master::config':
  puppetdb_server           => 'puppetmaster.cloud.gwdg.de',
  puppetdb_port             => '8081',
}

# Setup apt-cacher-ng
class {'aptcacherng':
#  cachedir => '/data/apt/apt-cacher-ng'
}
