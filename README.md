=============================
Docker APSL LAMP base project
=============================

Apache image managed with circus. Config parameters with envtpl. apache, proftpd and sshd managed by circus.

Description
===========

Apache generic image with these features:

Work in progress. This image is intended to be used as base Dockerfile for
projects where you should need sftp and ssh access. But probably, if you need
ssh access, you are doing it wrong ;)
http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/

* envtpl to configure apache mpm prefork parameters. Also can be used for inherited Dockerfiles.
* circus to control processes. http://circus.readthedocs.org/
* sshd
* proftpd for sftp
* single cron for apache logrotation

See base image *apsl/circusbase* for more info:

https://registry.hub.docker.com/u/apsl/circusbase/
https://github.com/APSL/docker-circusbase


Environ vars
============

Below you have a list of configurable env vars with default values shown.

Apache mpm prefork settings (*see conf/mpm_prefork.conf.tpl*)::

    -e WORKERS_MIN=5     # sets StartServers and MinSpareServers
    -e WORKERS_SPARE=10  # sets MaxSpareServers
    -e WORKERS_MAX=100   # sets Maxclients and ServerLimit

Default virtualhost::

    -e DOMAIN=hostname   # defaults to container hostname. see conf/default-vhost.tpl

Apache basic auth::

    -e BASIC_AUTH=myuser:mypasswd   # disabled by default

If configured, it will add http basic auth for all hosts

SFTP/SSH user:: 

    -e FTP_USER=myuser:mypasswd     # disabled by default

SSH public key::

    -e SSH_KEY="ssh-dss AAAA...."   # disabled by default


Exposed ports
=============

* 80: apache
* 22: sshd if enabled
* 2221: proftpd if enabled


Get started
===========

For an example using as a base image, see apsl/wordpress:

https://registry.hub.docker.com/u/apsl/wordpress/dockerfile/

Using standalone
----------------

1. clone::

    git clone https://github.com/APSL/docker-lamp.git

2. build::

    cd docker-lamp
    docker build -t lamp .

3. run::

    docker run -v /var/www:/app/www -p 80:80 lamp 

OR use docker registry hub: 

1. pull: 
    docker pull apsl/lamp

2. run: 
    docker run  -p 80:80 apsl/lamp 


