#!/bin/bash


set |grep '_PORT_' |tr  '=' ' ' |sed 's/^/SetEnv /' > /etc/apache2/conf-enabled/docker-vars.conf
set |grep '_ENV_' |tr  '=' ' ' |sed 's/^/SetEnv /' >> /etc/apache2/conf-enabled/docker-vars.conf
set |grep 'SERVER_NAME' |tr  '=' ' ' |sed 's/^/SetEnv /' >> /etc/apache2/conf-enabled/docker-vars.conf

set |grep '_PORT_'  |sed 's/^/export /'>> /etc/apache2/envvars

echo "export SERVER_NAME=$SERVERNAME" >> /etc/apache2/envvars

echo "ServerName $SERVER_NAME" >> /etc/apache2/conf-enabled/servername.conf




/etc/init.d/apache2 start && \
tail -F /var/log/apache2/*log

#service rsyslog start && \
#service postfix start && \
#tail -F /var/log/mail.log
