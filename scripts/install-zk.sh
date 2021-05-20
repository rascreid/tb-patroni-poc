#!/bin/bash

sudo useradd zk -m
sudo usermod --shell /bin/bash zk
sudo bash -c "echo 'zk:zookeeper' | chpasswd"
sudo usermod -aG sudo zk

sudo mkdir -p /data/zookeeper
sudo chown zk:zk /data/zookeeper
sudo -u zk bash -c "echo "$1" > /data/zookeeper/myid"

sudo wget -qcP /opt https://apache.paket.ua/zookeeper/zookeeper-3.6.3/apache-zookeeper-3.6.3-bin.tar.gz
sudo tar -xzvf /opt/apache-zookeeper-3.6.3-bin.tar.gz -C /opt/
sudo rm /opt/apache-zookeeper-3.6.3-bin.tar.gz


sudo chown zk:zk -R /opt/apache-zookeeper-3.6.3-bin/
sudo ln -s /opt/apache-zookeeper-3.6.3-bin /opt/zookeeper
sudo chown -h zk:zk /opt/zookeeper