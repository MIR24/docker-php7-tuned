#/bin/bash
a2enmod rewrite
a2dismod mpm_event
a2enmod mpm_prefork
service apache2 restart
