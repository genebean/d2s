# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'genebean/centos-7-puppet-agent'

  if Vagrant.has_plugin?('vagrant-cachier')
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
  end

  config.vm.hostname = 'dockerhost.localdomain'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000

  config.vm.provision 'shell', inline: 'puppet module install garethr-docker --version 5.3.0'
  config.vm.provision 'shell', inline: 'puppet apply /vagrant/docker.pp'
  config.vm.provision 'shell', inline: 'docker ps'
end
