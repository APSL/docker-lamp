<Directory />
    {% if BASIC_AUTH %}
    AuthType Basic
    AuthName "{{ AUTHNAME| default('Restricted') }}"
    AuthUserFile /etc/apache2/basic-access
    Require valid-user
    {% endif %}
</Directory>
