FROM apsl/circusbase

MAINTAINER  APSL <bcabezas@apsl.net>

# apache2
RUN \
    apt-get -y install \
            apache2-mpm-prefork libapache2-mod-php5 php5-mysql \
            php5-gd php5-mcrypt php5-cli php5-memcached \
            php5-memcache php5-curl \
            && apt-get clean

ADD conf/apache2.conf /etc/apache2/
ADD conf/security.conf /etc/apache2/conf-available/
ADD conf/remoteip.conf /etc/apache2/mods-available/
ADD conf/mpm_prefork.conf.tpl /etc/apache2/mods-available/
ADD conf/apache-defaulthost.conf.tpl /etc/apache2/sites-available/app.conf.tpl
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
# apache setup run-parts configs (see parent image)
ADD setup.d/apache-defaulthost /etc/setup.d/90-apache-defaulthost
ADD setup.d/apache-auth /etc/setup.d/50-apache-auth
ADD setup.d/apache-prefork /etc/setup.d/50-apache-prefork
ADD circus.d/apache.ini /etc/circus.d/
# end apache2

#ssh
RUN \
    apt-get install openssh-server && apt-get clean ;\
    mkdir /var/run/sshd ;\
    chmod 0755 /var/run/sshd ;\
    mkdir /root/.ssh;chmod 700 /root/.ssh 
ADD conf/pam-sshd /etc/pam.d/sshd
ADD setup.d/config-ssh /etc/setup.d/10-config-ssh
ADD circus.d/sshd.ini /etc/circus.d/
# end ssh

#proftpd
RUN apt-get install proftpd-basic && apt-get clean 
ADD conf/proftpd.conf /etc/proftpd/proftpd.conf
ADD conf/sftp.conf /etc/proftpd/conf.d/
ADD circus.d/sftp.ini /etc/circus.d/
ADD setup.d/config-sftp /etc/setup.d/10-config-sftp

# logrotate + cron
ADD conf/crontab /etc/crontab
ADD conf/logrotate.conf /etc/logrotate.conf

# base phpinfo app (inherited images will add custom app)
ADD www /app/www
RUN mkdir /app/logs

EXPOSE 80 22 2221
CMD /bin/start.sh
