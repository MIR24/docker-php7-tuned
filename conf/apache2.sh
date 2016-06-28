#/bin/bash
a2enmod rewrite
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod php7.0
service apache2 restart
