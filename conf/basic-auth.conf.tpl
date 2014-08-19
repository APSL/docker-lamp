{% if BASIC_AUTH_ENABLED %}
<Directory />
    AuthType Basic
    AuthName "{{ BASIC_AUTHNAME| default('Restricted') }}"
    AuthUserFile /etc/apache2/basic-access
    Require valid-user
</Directory>
{% endif %}
