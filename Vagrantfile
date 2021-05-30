# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"
  config.vbguest.auto_update = false

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision/playbook.yml"

    ansible.groups = {
      "db" => ["pg[1:2]"],
      "zk" => ["tb"],
      "tb" => ["tb"]
    }

    ansible.host_vars = {
      "pg1" => {"ansible_ssh_extra_args" => '-o StrictHostKeyChecking=no', "my_ip" => "10.0.1.10"},
      "pg2" => {"ansible_ssh_extra_args" => '-o StrictHostKeyChecking=no', "my_ip" => "10.0.1.20"},

      "tb" => {"ansible_ssh_extra_args" => '-o StrictHostKeyChecking=no', "my_ip" => "10.0.1.30", "my_id" => "3", "jdk_ver" => "11",
      "pg1_ip" => "10.0.1.10", "pg2_ip" => "10.0.1.20",
      "tb_url" => "https://github.com/thingsboard/thingsboard/releases/download/v3.2.2/thingsboard-3.2.2.deb",}

    }
  end


 $SCRIPT =<<-SCRIPT
  #!/bin/bash
  ScriptBlock
 SCRIPT

 $DisablePG = <<-SCRIPT
  #!/bin/bash
  sudo bash -c "systemctl stop postgresql ; systemctl disable postgresql"
 SCRIPT

#  $CopyTBConfig =<<-SCRIPT
#   #!/bin/bash
#   sudo bash -c "curl -s https://gist.githubusercontent.com/rascreid/d73d48fa8c6010cd6714652996bd6887/raw/711de94b2f67be094f9c0f7ece2aee0116de61cc/thingsboard.conf  > /etc/thingsboard/conf/thingsboard.conf"
#  SCRIPT

#  $ProvisionPatroni =<<-SCRIPT
#   #!/bin/bash
#   sudo bash -c "curl -s https://gist.githubusercontent.com/rascreid/3d34389efcacb63e670cf456cf2336c1/raw/498a23e07cc3fb23fd641edb9271f51a308368d5/patroni.service > /etc/systemd/system/patroni.service"
#   sudo bash -c "curl -s https://gist.githubusercontent.com/rascreid/1a120358103e12042dd89b1fbb021a7f/raw/d0d3230b345568061a91a81764664a8c6efa589f/patroni.yml > /etc/patroni/patroni.yml"
#  SCRIPT
 
#  $ProvisionZookeper =<<-SCRIPT
#  #!/bin/bash

#   sudo bash -c "curl -s https://gist.githubusercontent.com/rascreid/775037b7ea6adb48f9bfade01098c2c2/raw/2d1f44f2bf4dde1188b3bf39e7838d873a1d7e6f/zoo.cfg > /opt/zookeeper/conf/zoo.cfg"
#   sudo bash -c "curl -s https://gist.githubusercontent.com/rascreid/22f7e857e7bcf90558b88b5af8f9d648/raw/6d16000ed25eea14453877338bd2afe887a53396/zookeeper.service > /etc/systemd/system/zookeeper.service"
 
#   sudo systemctl start zookeeper
#   sudo systemctl enable zookeeper
#  SCRIPT


    config.vm.define "pg1" do |pg1|
      pg1.vm.network "private_network", ip: "10.0.1.10"
      pg1.vm.hostname = "pg1"

      pg1.vm.provision "shell", path: "https://gist.githubusercontent.com/rascreid/6d9345b3a6ec86d59cbab346b422401a/raw/f59d20922fd47b7ed5e9df66bab4dbda381b3ed7/install-x-PostgreSQL.sh" do |s|
        s.args = "12" #Version-12
      end
      pg1.vm.provision "shell", inline: $DisablePG

    end

  config.vm.define "pg2" do |pg2|
    pg2.vm.network "private_network", ip: "10.0.1.20"
    pg2.vm.hostname = "pg2"

    pg2.vm.provision "shell", path: "https://gist.githubusercontent.com/rascreid/6d9345b3a6ec86d59cbab346b422401a/raw/f59d20922fd47b7ed5e9df66bab4dbda381b3ed7/install-x-PostgreSQL.sh" do |s|
      s.args = "12" #Version-12
    end
    pg2.vm.provision "shell", inline: $DisablePG

  end

  config.vm.define "tb" do |tb|
    tb.vm.network "private_network", ip: "10.0.1.30"
    tb.vm.hostname = "tb"

    #tb.vm.provision "shell", path: "https://gist.githubusercontent.com/rascreid/629c4c163e2d70b6f775a729d32850c9/raw/c38aac1a754b0d13884e142aec4fe0b4cdf99046/install-x-jdk.sh" do |s|
    #  s.args = "11" #JDK-11
    #end

    #tb.vm.provision "shell", path: "https://gist.githubusercontent.com/rascreid/71244050792caf294dbbf2a68ea30388/raw/eed4ca2ab9f3e4d11a0a48a98ff25298f8837d2f/install-zk.sh" do |s|
    #  s.args = "3" #ID
    #end
    #tb.vm.provision "shell", inline: $ProvisionZookeper

    #tb.vm.provision "shell", path: "https://gist.githubusercontent.com/rascreid/67bbca8414d4825f3b6245bd0e45f262/raw/9c09710757aee4d062106850c3179e3f81ba0657/install-tb-322"
    #tb.vm.provision "shell", inline: $CopyTBConfig

  end

end