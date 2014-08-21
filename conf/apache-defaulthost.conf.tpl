<VirtualHost *:80>
    DocumentRoot /app/www
    ServerName {{ DOMAIN | default(HOSTNAME) }}
    ErrorLog /app/logs/error.log
    CustomLog /app/logs/access.log common

    <Directory /app/www>
        Options  FollowSymLinks MultiViews
        AllowOverride all
        Order allow,deny
        Allow from all
        DirectoryIndex index.php
        SetEnvIfNoCase  X-Forwarded-Proto HTTPS HTTPS=on
    </Directory>
    <FilesMatch "\.tpl$">
        order deny,allow
        deny from all
    </FilesMatch>
</VirtualHost>
