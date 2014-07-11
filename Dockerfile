FROM ubuntu:14.04
MAINTAINER  APSL <bcabezas@apsl.net>
ENV DEBIAN_FRONTEND noninteractive

# REPOS
# http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/
RUN \
    echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90forceyes;\
    echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe' > /etc/apt/sources.list;\
    apt-get update;\
    echo exit 101 > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d;\
    dpkg-divert --local --rename --add /sbin/initctl;\
    ln -sf /bin/true /sbin/initctl;\
    apt-get -y upgrade && apt-get clean

# timezone Europe/Madrid
RUN \
    echo "Europe/Madrid" > /etc/timezone ;\
    rm -f /etc/localtime ;\
    ln -sf /usr/share/zoneinfo/Europe/Madrid  /etc/localtime

RUN \
    apt-get -y install apache2-mpm-prefork libapache2-mod-php5 \
            php5-mysql php5-gd php5-mcrypt php5-cli php5-memcached php5-memcache php5-curl unzip wget \
            python python-distribute python-pip python-jinja2 memcached && apt-get clean

RUN apt-get -y install vim-tiny && apt-get clean

# circus + circus-web
RUN \
    apt-get -y  install python-zmq python-gevent python-gevent-websocket \
      python-bottle python-mako python-anyjson python-greenlet \
      python-beaker python-psutil python-tornado  && apt-get clean 

RUN \
    pip install circus==0.10.0 ;\
    pip install circus-web==0.4.1

RUN pip install envtpl

# apache2
ADD conf/apache2.conf /etc/apache2/
ADD conf/security.conf /etc/apache2/conf-available/
ADD conf/remoteip.conf /etc/apache2/mods-available/
ADD conf/mpm_prefork.conf.tpl /etc/apache2/mods-available/
ADD conf/apache-defaulthost.conf.tpl /etc/sites-available/app.conf.tpl
RUN \
    rm /etc/apache2/sites-enabled/* -f ;\
    a2enmod rewrite ;\
    a2enmod expires ;\
    a2enmod headers ;\
    a2enmod deflate ;\
    a2enmod remoteip ;\
    php5enmod mcrypt ;\
    php5enmod memcached ;\
    php5enmod opcache  
RUN \
    mkdir -p /var/www/logs ;\
    rm -fr /var/www/html
# apache start.sh run-parts configs
ADD start.d/apache-defaulthost /etc/start.d/90-apache-defaulthost
ADD start.d/apache-auth /etc/start.d/50-apache-auth
ADD start.d/apache-prefork /etc/start.d/50-apache-prefork
# end apache2

#ssh
RUN \
    apt-get install openssh-server && apt-get clean ;\
    mkdir /var/run/sshd ;\
    chmod 0755 /var/run/sshd ;\
    mkdir /root/.ssh;chmod 700 /root/.ssh 
ADD conf/pam-sshd /etc/pam.d/sshd
ADD start.d/config-ssh /etc/start.d/10-config-ssh
# end ssh

#proftpd
RUN apt-get install proftpd-basic && apt-get clean 
ADD conf/proftpd.conf /etc/proftpd/proftpd.conf
ADD conf/sftp.conf /etc/proftpd/conf.d/
ADD start.d/config-sftp /etc/start.d/10-config-sftp

# logrotate + cron
ADD conf/crontab /etc/crontab
ADD conf/logrotate.conf /etc/logrotate.conf

# circus conf
ADD conf/circus.ini  /etc/

# start script
ADD start.sh /bin/

# app
ADD www /app/www
RUN mkdir /app/logs

EXPOSE 80 22 2221
CMD /bin/start.sh
