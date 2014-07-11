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

Get started
===========

1. clone::

    git clone https://github.com/APSL/docker-lamp.git

2. build::

    cd docker-lamp
    docker build -t lamp .

3. run::

    docker run  -p 8080:80 apsl/lamp 

OR use docker registry hub: 

1. pull: 
    docker pull apsl/lamp

2. run: 
    docker run  -p 8080:80 apsl/lamp 


lamp script usage
=================
TODO


