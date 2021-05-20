# TB-Patroni-POC

You should be able to use this repo to quicly deploy and test PostgreSQL HA on Patroni with Thingsboard.

VMs that will be deployed:
- 2 VMs with PostgreSQL (pg1/pg2)
- 1 VM with ThingBoard+Zookeper (tb)

Feel free to edit Vagrant file for any customizations.

## Prerequisites
---
You would need a [Vagrant](https://www.vagrantup.com/docs/installation) installed to follow along.

>This deployment has been tested on Ubuntu+VirtualBox

## Getting Started
---
Before starting Vagrant adjust network settings on the machines and change it to your NIC.

*x.vm.network "public_network", bridge: "enp8s0"*

When all done, to start run:

```
vagrant up
```

To login run:

```
vagrant ssh vmname
```
# Configuration

### PG1

- Login to the first PostgreSQL server

```
vagrant ssh pg1
```
- Edit patroni configuration file

```
sudo vi /etc/patroni/patroni.yml
```
>Change name to pg1 and replace x.x.x.x with corresponding IP addresses. For complete information on configuration options refer to the [Patroni documentation](https://patroni.readthedocs.io/en/latest/dynamic_configuration.html)

- Start patroni service and add it to autostart


```
sudo systemctl start patroni.service && sudo systemctl enable patroni.service
```
- Check its status and logs

```
systemctl status patroni.service
```

```
sudo journalctl -u patroni
```

- Create ThingsBoard Database

```
psql -U postgres -h localhost -c "CREATE DATABASE thingsboard;"
```

## PG2

- Login to second PostgreSQL server

```
vagrant ssh pg2
```
- Edit patroni configuration file

```
sudo vi /etc/patroni/patroni.yml
```
>Change name to pg2 and replace x.x.x.x with corresponding IP addresses. 

- Start patroni service and add it to autostart


```
sudo systemctl start patroni.service && sudo systemctl enable patroni.service
```
- Check its status and logs

```
systemctl status patroni.service
```

```
sudo journalctl -u patroni
```

## TB

```
vagrant ssh tb
```

Edit **SPRING_DATASOURCE_URL** environment in thingsboard.conf and repace **x.x.x.x** to ip addresses for pg1 and pg2

```
sudo vi /etc/thingsboard/conf/thingsboard.conf 
```

> **Target_session_attrs=read-write**
The PostgreSQL client will not accept a connection to a server where it cannot modify data. This allows you to connect to the streaming replication primary, regardless of the order of the servers in the connection string. Is a simple but still operating method to route requests between master/slave that is natively supported by the drivers (not all options available within different drivers).
Refer to [PostgreSQL documentation](https://www.postgresql.org/docs/10/libpq-connect.html) for more information on this. Also, other options available to forward PostgreSQL requests ([HAProxy/pgbouncer](https://github.com/zalando/patroni/tree/master/extras/confd) etc)


### Install TB and Start service

```
sudo /usr/share/thingsboard/bin/install/install.sh --loadDemo && sudo service thingsboard start
```

Once started, you will be able to open Web UI using the following link:

```
http://x.x.x.x:8080
```

The following default credentials are available if you have specified –loadDemo during execution of the installation script:

```
System Administrator: sysadmin@thingsboard.org / sysadmin
Tenant Administrator: tenant@thingsboard.org / tenant
Customer User: customer@thingsboard.org / customer
```

## Patronictl
---

### Executing commands

Login as postgres user and use  patronictl 

```
sudo su - postgres

patronictl -c /etc/patroni/patroni.yml command
```

or
```
sudo -iu postgres patronictl -c /etc/patroni/patroni.yml command
```

### Listing

```
sudo -iu postgres patronictl -c /etc/patroni/patroni.yml list

```
```
+ Cluster: thingsboard (6964427273370993718) +----+-----------+
| Member | Host          | Role    | State   | TL | Lag in MB |
+--------+---------------+---------+---------+----+-----------+
| pg1    | 192.168.1.133 | Leader  | running |  1 |           |
| pg2    | 192.168.1.108 | Replica | running |  1 |         0 |
+--------+---------------+---------+---------+----+-----------+
```

### SwitchOver

Is a manual operation, will switch a master role to a new node. Requires the presence of a master.

```
sudo -iu postgres patronictl -c /etc/patroni/patroni.yml switchover
```
```
Master [pg1]: 
Candidate ['pg2'] []: 
When should the switchover take place (e.g. 2021-05-20T19:05 )  [now]: 
Current cluster topology
+ Cluster: thingsboard (6964427273370993718) +----+-----------+
| Member | Host          | Role    | State   | TL | Lag in MB |
+--------+---------------+---------+---------+----+-----------+
| pg1    | 192.168.1.133 | Leader  | running |  1 |           |
| pg2    | 192.168.1.108 | Replica | running |  1 |         0 |
+--------+---------------+---------+---------+----+-----------+
Are you sure you want to switchover cluster thingsboard, demoting current master pg1? [y/N]: y
2021-05-20 18:06:02.32059 Successfully switched over to "pg2"
+ Cluster: thingsboard (6964427273370993718) +----+-----------+
| Member | Host          | Role    | State   | TL | Lag in MB |
+--------+---------------+---------+---------+----+-----------+
| pg1    | 192.168.1.133 | Replica | stopped |    |   unknown |
| pg2    | 192.168.1.108 | Leader  | running |  1 |           |
+--------+---------------+---------+---------+----+-----------+
```

Run list again to get information on current status

```
sudo -iu postgres patronictl -c /etc/patroni/patroni.yml list
```

### Failover

An emergency promotion of a PostgreSQL node in case of failure. (From the output above pg2 is a leader)

```
vagrant ssh pg2
```

```
sudo systemctl poweroff
```

```
vagrant ssh pg1
```
```
vagrant@pg1:~$ date && sudo -iu postgres patronictl -c /etc/patroni/patroni.yml list
Thu May 20 18:22:16 UTC 2021

+ Cluster: thingsboard (6964427273370993718) +----+-----------+
| Member | Host          | Role    | State   | TL | Lag in MB |
+--------+---------------+---------+---------+----+-----------+
| pg1    | 192.168.1.133 | Replica | running |  2 |         0 |
| pg2    | 192.168.1.108 | Leader  | running |  2 |           |
+--------+---------------+---------+---------+----+-----------+
vagrant@pg1:~$ date && sudo -iu postgres patronictl -c /etc/patroni/patroni.yml list

Thu May 20 18:22:48 UTC 2021

+ Cluster: thingsboard (6964427273370993718) +----+-----------+
| Member | Host          | Role    | State   | TL | Lag in MB |
+--------+---------------+---------+---------+----+-----------+
| pg1    | 192.168.1.133 | Leader  | running |  3 |           |
| pg2    | 192.168.1.108 | Replica | stopped |    |   unknown |
+--------+---------------+---------+---------+----+-----------+
```

### Configuring

A cluster-wide configuration or the separate node configuration

```
sudo -iu postgres patronictl -c /etc/patroni/patroni.yml edit-config
```

### Get Help

```
sudo -iu postgres patronictl -c /etc/patroni/patroni.yml --help
```

> For the complete list of operation refer to the Patroni [REST API documentation](https://patroni.readthedocs.io/en/latest/rest_api.html?highlight=patronictl)