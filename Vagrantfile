# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.host = "fj2.citozin.com"
    libvirt.username = "root"
    libvirt.connect_via_ssh = true
  end
  config.vm.box = "centos7"

  # ambari_server
  config.vm.define :ambari_server do |node|
    node.vm.hostname = "aserv"
    node.vm.box = "centos7"
    node.vm.provider :libvirt do |domain|
      domain.memory = 6000
      domain.cpus = 2
    end
  end

  # ambari_agent
  config.vm.define :ambari_agent do |node|
    node.vm.hostname = "age"
    node.vm.box = "centos7"
    node.vm.provider :libvirt do |domain|
      domain.memory = 12_000
      domain.cpus = 2
    end
  end
end
