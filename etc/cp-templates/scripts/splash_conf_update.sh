#!/bin/bash

################################################
####### Updating Splash Server Configuration #######
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf


### Updating Splashpage Server configuration file
sed -i "/APP_URL.*/c\\APP_URL=${WEB_APP_SERVER_URL}" /etc/splash_page_server.conf

sed -i "/RABBITMQ_HOSTNAME.*/c\\RABBITMQ_HOSTNAME=${WEB_RABBITMQ_HOSTNAME}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_PORT=.*/c\\RABBITMQ_PORT=${WEB_RABBITMQ_PORT}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_USERNAME=.*/c\\RABBITMQ_USERNAME=${WEB_RABBITMQ_USERNAME}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_PASSWORD=.*/c\\RABBITMQ_PASSWORD=${WEB_RABBITMQ_PASSWORD}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_EXCHANGE=.*/c\\RABBITMQ_EXCHANGE=${WEB_RABBITMQ_EXCHANGE}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_BINDING_KEY=.*/c\\RABBITMQ_BINDING_KEY=${WEB_RABBITMQ_BINDING_KEY}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_VHOST=.*/c\\RABBITMQ_VHOST=/" /etc/splash_page_server.conf

### Creating log file for Splash Server
[ ! -d /var/log/captiveportal/web ] && mkdir -p /var/log/captiveportal/web
chown -R root.adm /var/log/captiveportal/web
[ ! -f /var/log/captiveportal/web/splashsever.log ] && touch /var/log/captiveportal/web/splashserver.log
chown syslog.adm /var/log/captiveportal/web/splashsever.log
