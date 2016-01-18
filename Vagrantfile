# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
$first_line = ""

Vagrant.configure(2) do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.host = "fj2.citozin.com"
    libvirt.username = "root"
    libvirt.connect_via_ssh = true
  end
  # config.vm.provision do |chef|
  #   chef.cookbooks_path=["cookbooks"]
  # end
    config.vm.box = "centos7"

  # ambari_server
  config.vm.define :ambari_server do |node|
    node.vm.hostname = "fed.ambari.server"
    node.vm.box = "centos7"
    node.vm.network :private_network, :ip => "10.20.30.40"
    node.vm.provision "shell", inline: "echo AmbariServer!!"
    node.vm.provision "shell", inline: "sudo yum -y install nano"
    node.vm.provision "shell", inline: "sudo yum -y install expect"
    node.vm.provision "shell", inline: "sudo yum install -y unzip"
    # node.vm.provision "shell", inline: "sudo wget -nv https://dl.ngrok.com/ngrok_2.0.19_linux_amd64.zip /home/vagrant/ngrok.zip"
    # node.vm.provision "shell", inline: "unzip /home/vagrant/ngrok* /home/vagrant/"
    # $first_line = (node.vm.provision "shell", inline: "/sbin/ifconfig")
    node.vm.provision "shell", inline: "sudo wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo"
    node.vm.provision "file",
      source: "/home/alfe/mkdev/bigdata/cluster/testblueprint.json",
      destination: "/home/vagrant/testblueprint.json"
    node.vm.provision "shell",
      inline: 'echo "10.20.30.41 fed.ambari.agent" | sudo tee --append /etc/hosts > /dev/null'
    node.vm.provision "shell", inline: "sudo yum -y install ambari-server"
    node.vm.provision "shell", path: "/home/alfe/mkdev/bigdata/cluster/ambsersetup.sh"
    # node.vm.provision "shell", inline: 'sudo expect -c "spawn sudo ambari-server setup; expect continue;sleep 5; send y\n; expect ambari-server; sleep 5; send y\n ;expect daemon; sleep 5; send amsdae\n;expect \'choice (1)\'; sleep 5; send 1\n;expect \'License Agreement\'; sleep 5; send y\n;expect \'advanced database\'; sleep 5; send y\n;expect \'choice (1)\'; sleep 5; send 1\n; expect \'Database name\';sleep 5; send  ambari\n; expect \'Postgres schema\';sleep 5; send ambari\n;expect \'Username\'; sleep 5; send ambari\n;expect bigdata; sleep 5;send bigdata\n;  interact"'
    # node.vm.provision "file",
    #   source: "/home/alfe/mkdev/bigdata/cluster/ambsersetup.sh",
    #   destination: "/home/vagrant/ambsersetup.sh"
    # node.vm.provision "shell", inline: "sh /home/vagrant/ambsersetup.sh" 
    node.vm.provision "shell", inline: "echo Pause"
    # node.vm.provision "shell", inline: "sudo -u postgres psql -U postgres -d postgres -c "alter user ambari with password 'bigdata';""
    node.vm.provision "shell", inline: "sudo ambari-server start"
    node.vm.provision "shell", inline: 'curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/testblueprint.json" -u admin:admin -X POST http://localhost:8080/api/v1/blueprints/testblueprint'
    node.vm.provision "shell", inline: 'curl  -i -H "X-Requested-By: ambari" --data "@/home/vagrant/creationtempl.json" -u admin:admin -X POST http://localhost:8080/api/v1/clusters/test'
    node.vm.provider :libvirt do |domain|
      domain.memory = 6000
      domain.cpus = 2
    end
    
  end

  # ambari_agent
  config.vm.define :ambari_agent do |node|
    node.vm.hostname = "fed.ambari.agent"
    node.vm.box = "centos7"
    node.vm.network :private_network, :ip => "10.20.30.41"
    node.vm.provision "shell", inline: "echo AmbariAgent!!"
    node.vm.provision "shell", inline: "sudo yum -y install nano"
    node.vm.provision "shell", inline: "sudo yum -y install ntp"
    node.vm.provision "shell", inline: "sudo systemctl start ntpd"
    node.vm.provision "shell", inline: "/sbin/ifconfig"
    node.vm.provision "shell", inline: "sudo wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0/ambari.repo -O /etc/yum.repos.d/ambari.repo"
    node.vm.provision "file",
      source: "/home/alfe/mkdev/bigdata/cluster/creationtempl.json",
      destination: "/home/vagrant/creationtempl.json"
    node.vm.provision "shell", inline: "sudo yum -y install ambari-agent"
    node.vm.provision "shell",
      inline: 'echo "10.20.30.40 fed.ambari.server" | sudo tee --append /etc/hosts > /dev/null'
    node.vm.provision "shell",
      inline: 'sudo sed -i "16s/.*/hostname=fed.ambari.server/" /etc/ambari-agent/conf/ambari-agent.ini'
    node.vm.provider :libvirt do |domain|
      domain.memory = 12_000
      domain.cpus = 2
    end
  end
end
