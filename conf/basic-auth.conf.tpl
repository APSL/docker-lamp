{% if BASIC_AUTH %}
<Directory />
    AuthType Basic
    AuthName "{{ BASIC_AUTH_NAME| default('Restricted') }}"
    AuthUserFile /etc/apache2/basic-access
    Require valid-user
</Directory>
{% endif %}
