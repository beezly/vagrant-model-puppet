# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  number_puppet_masters = 2

  standalone_puppet_ca = number_puppet_masters > 1 ? true : false
 
  puppet_master_memory = 512
  puppet_ca_memory = 512
  haproxy_memory = 256
  default_box = "puppetlabs/centos-6.5-64-puppet"

  number_puppet_masters.times do |puppet_master_id|
    config.vm.define "puppetmaster-#{puppet_master_id}" do |puppetmaster|
      puppetmaster.vm.box = default_box
      puppetmaster.vm.network "private_network", type: "dhcp"
 
      puppetmaster.vm.provider "virtualbox" do |v|
        v.memory = puppet_master_memory
      end
    end
  end

  if standalone_puppet_ca 
    config.vm.define "puppet-ca" do |puppetca|
      puppetca.vm.box = default_box
      puppetca.vm.network "private_network", type: "dhcp"

      puppetca.vm.provider "virtualbox" do |v|
        v.memory = puppet_ca_memory
      end
    end
  end

  config.vm.define "haproxy" do |haproxy|
    haproxy.vm.box = default_box
    haproxy.vm.network "private_network", type: "dhcp"

    haproxy.vm.provider "virtualbox" do |v|
      v.memory = haproxy_memory
    end

    config.vm.provision "puppet" do |puppet|
      puppet.manifest_file = "haproxy.pp"
      puppet.module_path = "modules"
    end

  end

end
