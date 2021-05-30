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
  end # provision "ansible"

 $DisablePG = <<-SCRIPT
  #!/bin/bash
  sudo bash -c "systemctl stop postgresql ; systemctl disable postgresql"
 SCRIPT

<<<<<<< HEAD

=======
>>>>>>> dev
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
<<<<<<< HEAD


=======
>>>>>>> dev
  end

end