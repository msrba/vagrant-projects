# -*- mode: ruby -*-
# vi: set ft=ruby :

# Types of boxes to be used

box_cloud = {
    :box        => "ubuntu-14.04",
    :box_url    => "http://wwwuser.gwdg.de/~pkasprz/vagrant-ubuntu-14.04.box" 
}

# Environment definition for memory restricted environment (i.e. 8 GB laptop)
# !!! NOTE: This configuration is obsolete and will not work anymore !!!

# Minimal memory requirements

# puppetmaster:	768 MB

# Environment definition for hosts woth a lot of memory (>64 GB)

environment = {

    # --------------------------------------- Logging nodes -----------------------------------------

    # Puppetmaster
    :puppetmaster => {
        :hostname   => "puppetmaster.cloud.gwdg.de",
        :box        => box_cloud,
        :memory     => 1024,
        :cores      => 2,
        :networks   => [
            {   :ip => "10.1.254.2",    :netmask => "255.255.255.0" }   # Provisioning network 
        ],
        :provisioner    => [
            {:type => 'shell', :path => 'scripts/provision_puppetmaster.sh'}
        ],
    },

    # --------------------------------------- ElasticSearch -----------------------------------------

    # Projects node
    :projects => {
        :hostname   => "projects.gwdg.de",
        :box        => box_cloud,
        :memory     => 1024,
        :cores      => 2,
        :networks   => [
            {   :ip => "10.1.254.50",   :netmask => "255.255.255.0" },  # Provisioning network
            {   :ip => "10.1.1.50",     :netmask => "255.255.255.0" },  # Management network

            {   :ip => "10.1.100.50",   :netmask => "255.255.255.0" },  # Public network
        ], 
        :provisioner    => [
            {:type => 'shell', :path => 'scripts/provision_projects_node.sh'}
        ],       
        :port_forward => [
            {   :guest => 80,           host: 8080 },                # Redmine 
        ],
    },

}

# Provision environment

Vagrant.configure("2") do |config|

    # General virtualbox settings
    config.vm.provider :virtualbox do |vb|
#        vb.gui = true
    end

	config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    environment.each do |node, env_config|
		
        config.vm.define node do |vm_config|

            vm_config.vm.hostname   = env_config[:hostname]
            vm_config.vm.box        = env_config[:box][:box]
            vm_config.vm.box_url    = env_config[:box][:box_url]

            vm_config.ssh.password  = "vagrant"

            vm_config.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory",  env_config[:memory]]
                vb.customize ["modifyvm", :id, "--cpus",    env_config[:cores]]     unless env_config[:cores].nil?
                vb.customize ["modifyvm", :id, "--vrde", "on"]                      unless env_config[:vrdp].nil?
                vb.customize ["modifyvm", :id, "--vrdeport", env_config[:vrdp]]     unless env_config[:vrdp].nil?
                vb.customize ["modifyvm", :id, "--vrdemulticon", "on"]              unless env_config[:vrdp].nil?
            end

            # Define networks
            unless env_config[:networks].nil?
                env_config[:networks].each do |network_config|
                    do_auto_config = network_config[:auto_config].nil? ? true : network_config[:auto_config]
                    vm_config.vm.network :private_network, ip: network_config[:ip], netmask: network_config[:netmask], auto_config: do_auto_config
                end
            end

            # Define portforwarding
            unless env_config[:port_forward].nil?
                env_config[:port_forward].each do |port_forward_config|
                    vm_config.vm.network :forwarded_port, guest: port_forward_config[:guest], host: port_forward_config[:host]
                end
            end

            # Provision scripts
            unless env_config[:provisioner].nil?
                env_config[:provisioner].each do |provisioner|
                   vm_config.vm.provision provisioner[:type], path: provisioner[:path]
                end
            end
        end
    end
end
