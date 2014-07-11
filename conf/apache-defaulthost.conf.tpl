<VirtualHost *:80>
    DocumentRoot /app/www
    ServerName {{ DOMAIN | default(HOSTNAME) }}
    ErrorLog /app/logs/error.log
    CustomLog /app/logs/access.log common

    <Directory /app/www>
        Options  FollowSymLinks MultiViews
        Require all granted
        AllowOverride all
        Order allow,deny
        Allow from all
        DirectoryIndex index.php
        SetEnvIfNoCase  X-Forwarded-Proto HTTPS HTTPS=on
        <IfModule mod_rewrite.c>
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.php$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.php [L]
        </IfModule>
    </Directory>
    <FilesMatch "\.tpl$">
        order deny,allow
        deny from all
    </FilesMatch>
</VirtualHost>
