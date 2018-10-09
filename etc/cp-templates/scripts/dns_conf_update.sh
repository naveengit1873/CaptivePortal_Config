#!/bin/bash

################################################
####### Updating DNS Server Configuration #######
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf
#source /etc/captiveportal/conf.d/dns-server.conf


### Copying config files from template
cp /etc/cp-templates/dns/named.conf.tmpl /etc/bind/named.conf
cp /etc/cp-templates/dns/named.conf.options.tmpl /etc/bind/named.conf.options

### Updating DNS Manager configuration file
sed -i "/APP_URL.*/c\\APP_URL=${WEB_APP_SERVER_URL}" /etc/dns_manager.conf
sed -i "/RABBITMQ_HOSTNAME.*/c\\RABBITMQ_HOSTNAME=${WEB_RABBITMQ_HOSTNAME}" /etc/dns_manager.conf
sed -i "/RABBITMQ_PORT.*/c\\RABBITMQ_PORT=${WEB_RABBITMQ_PORT}" /etc/dns_manager.conf
sed -i "/RABBITMQ_USERNAME.*/c\\RABBITMQ_USERNAME=${WEB_RABBITMQ_USERNAME}" /etc/dns_manager.conf
sed -i "/RABBITMQ_PASSWORD.*/c\\RABBITMQ_PASSWORD=${WEB_RABBITMQ_PASSWORD}" /etc/dns_manager.conf
sed -i "/RABBITMQ_EXCHANGE.*/c\\RABBITMQ_EXCHANGE=${WEB_RABBITMQ_EXCHANGE}" /etc/dns_manager.conf
sed -i "/RABBITMQ_BINDING_KEY.*/c\\RABBITMQ_BINDING_KEY=${WEB_RABBITMQ_BINDING_KEY}" /etc/dns_manager.conf
sed -i "/RABBITMQ_VHOST.*/c\\RABBITMQ_VHOST=/" /etc/dns_manager.conf

### Creating log storage directories for DNS
[ ! -d /var/log/captiveportal/named ] && mkdir -p /var/log/captiveportal/named
[ ! -f /var/log/captiveportal/named/named.log ] && touch /var/log/captiveportal/named/named.log
[ ! -f /var/log/captiveportal/named/queries.log ] && touch /var/log/captiveportal/named/queries.log
chown syslog.adm /var/log/captiveportal/named/named.log
chown bind.root /var/log/captiveportal/named/queries.log