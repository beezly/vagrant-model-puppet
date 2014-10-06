A Model Puppet Environment built using Vagrant
==============================================

This is a model puppet config that you can deploy as a test environment
using Vagrant (available from http://vagrantup.com) and VirtualBox (available from http://virtualbox.org). You will also need librarian-puppet (http://librarian-puppet.com).

By default it will create three nodes:

- puppet-ca
- puppetmaster-1
- puppetmaster-2

puppet-ca is the centralised CA server. Certificates are created and signed on this mochine.

puppetmaster-1 and 2 are the puppet masters.

The puppet-ca machine is configured using the manifest file in manifests/default.pp

To build the three servers, run: 

    librarian-puppet install
    vagrant up
