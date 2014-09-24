# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  number_puppet_masters = 2

  puppet_master_memory = 512
  puppet_ca_memory = 512
  default_box = "puppetlabs/centos-6.5-64-puppet"
  puppet_master_addresses = []
  puppet_master_hostnames = []

  config.vm.define "puppet-ca" do |puppetca|
    puppetca.vm.box = default_box
    puppetca.vm.network "private_network", ip: "192.168.10.10"
    puppetca.vm.hostname = 'puppet-ca'

    puppetca.vm.provider "virtualbox" do |v|
      v.memory = puppet_ca_memory
    end
      
    puppetca.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
      puppet.hiera_config_path = "hiera.yaml"
    end
  end
  
  number_puppet_masters.times do |puppet_master_id|
    puppet_master_hostname = "puppetmaster-#{puppet_master_id+1}"
    puppet_master_hostnames << puppet_master_hostname

    config.vm.define "#{puppet_master_hostname}" do |puppetmaster|
      puppetmaster.vm.box = default_box

      puppetmaster_ip = "192.168.10.#{puppet_master_id+11}"
      puppet_master_addresses << puppetmaster_ip

      puppetmaster.vm.network "private_network", ip: puppetmaster_ip
      puppetmaster.vm.hostname = "puppetmaster-#{puppet_master_id+1}"
 
      puppetmaster.vm.provider "virtualbox" do |v|
        v.memory = puppet_master_memory
      end

      puppetmaster.vm.provision "puppet" do |puppet|
        puppet.module_path = "modules"
        puppet.hiera_config_path = "hiera.yaml"
      end
    end
  end
end
