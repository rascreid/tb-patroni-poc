#!/bin/bash

sudo apt update -y
sudo apt install -y python3-pip python3-dev libpq-dev
sudo -H pip3 install --upgrade pip
# Install Patroni with zookeper dependencies as postgres user
sudo -u postgres pip install psycopg2-binary
sudo -u postgres pip install patroni[zookeeper]
# Add patroni binaries to the postgre user PATH
echo "export PATH=$PATH:/var/lib/postgresql/.local/bin" | sudo tee -a /var/lib/postgresql/.bash_profile
# Fix permissions
sudo chown postgres:postgres /var/lib/postgresql/.bash_profile
# Create directory for configuration file
sudo mkdir /etc/patroni
