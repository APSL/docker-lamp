# prefork MPM

<IfModule mpm_prefork_module>
	StartServers	      {{ WORKERS_MIN | default(5) }}
	MinSpareServers		  {{ WORKERS_MIN | default(5) }}
	MaxSpareServers		 {{ WORKERS_SPARE | default(10) }}
	MaxRequestWorkers	  {{ WORKERS_MAX | default (100) }}
	MaxClients	  {{ WORKERS_MAX | default (100) }}
	ServerLimit	  {{ WORKERS_MAX | default (100) }}
	MaxConnectionsPerChild   0
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
