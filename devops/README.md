Docker Wordpress Teravisiontech
=============================
defines a docker containers running **Ubuntu Linux** with the LAMP stack installed.

#####Packages:
LAMP
====
* Composer
* PHP 
* Apache Server 

```bash
docker pull teravisiontech/wordpress
```
#####MYSQL
```bash
docker pull centos/mariadb
```
Usage
=====
#####Install docker
* 
MAC:   
    * https://docs.docker.com/engine/installation/mac/
    * https://github.com/docker/toolbox/releases/download/v1.11.2/DockerToolbox-1.11.2.pkg

* Linux:
```bash
 sudo curl -sSL https://get.docker.com/ | sh
```

#####Install  docker-compose:
```bash
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```
```bash
chmod +x /usr/local/bin/docker-compose
```
#####And..... RUN
```bash
docker-compose up -d
```

##### find NAT port HTTP
```bash
docker ps |grep 80
```


Test the LAMP server
================
Point your browser to:
http://localhost:PORT/

and you should see the default apache index. 
