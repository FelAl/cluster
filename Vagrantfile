# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|
  @vagrant_server = "fed.ambari.server"
  config.vm.provider :libvirt do |libvirt|
    libvirt.host = "69.64.34.35"
    libvirt.username = "root"
    libvirt.connect_via_ssh = true
  end
  config.vm.box = "centos7"

  # ambari_server
  config.vm.define :ambari_server do |node|
    node.vm.hostname = "fed.ambari.server"
    node.vm.box = "centos7"
    node.vm.network :private_network, :ip => "10.20.30.40"
    node.vm.network "forwarded_port", guest: 8080 , host: 10000
    node.vm.provision :hosts do |provisioner|
      provisioner.add_host '10.20.30.41', ['fed.ambari.agent']
    end

    node.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.verbose_logging = true
      chef.add_recipe "apt"
      chef.add_recipe "sysctl"
      chef.add_recipe "ohai"
      chef.add_recipe "yum-epel"
      chef.add_recipe "yum::server"
      chef.add_recipe "openvpn::install"
      chef.add_recipe "ambari::server"
      chef.add_recipe "mybook::server"
    end

    node.vm.provider :libvirt do |domain|
      domain.memory = 6000
      domain.cpus = 2
    end
  end

  # ambari_agent
  config.vm.define :ambari_agent do |node|
    node.vm.hostname = "fed.ambari.agent"
    node.vm.box = "centos7"
    node.vm.network :private_network, ip: "10.20.30.41"
    node.vm.network "forwarded_port", guest: 8080, host: 8888
    node.vm.network "forwarded_port", guest: 50070, host: 50070
    node.vm.provision :hosts do |provisioner|
      provisioner.add_host '10.20.30.40', ['fed.ambari.server']
    end

    node.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.verbose_logging = true
      chef.add_recipe "ohai"
      chef.add_recipe "sysctl::ambari_agent"
      chef.add_recipe "sysctl::apply"
      chef.add_recipe "iptables::default"
      #chef.add_recipe "iptables::agent"
      chef.add_recipe "yum::agent"
      chef.add_recipe "mybook::agent"
    end

    node.vm.provider :libvirt do |domain|
      domain.memory = 12_000
      domain.cpus = 2
    end
  end
end
