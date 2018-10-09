#!/bin/bash

################################################
####### Updating AAA Server Configuration #######
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf


if [[ ${RUN_APP_SERVER} -eq 1 && ${RUN_AAA_SERVER} -eq 1 ]]; then
	AAA_SOAP_RADIUS_BIND_IP=127.0.0.1
else
	AAA_SOAP_RADIUS_BIND_IP=`$AAA_SERVER_BIND_IP`
fi

### Updating Soapradius configuration file

sed -i "/APP_URL.*/c\\APP_URL=${AAA_APP_SERVER_URL}" /etc/soapradius/soapradius.conf
sed -i "/LISTEN_IP=.*/c\\LISTEN_IP=${AAA_SOAP_RADIUS_BIND_IP}" /etc/soapradius/soapradius.conf

sed -i "/MYSQL_HOSTNAME=.*/c\\MYSQL_HOSTNAME=${AAA_DATABASE_IP}" /etc/soapradius/soapradius.conf
sed -i "/MYSQL_PORT=.*/c\\MYSQL_PORT=${AAA_DATABASE_PORT}" /etc/soapradius/soapradius.conf
sed -i "/MYSQL_USERNAME=.*/c\\MYSQL_USERNAME=${AAA_DATABASE_USER}" /etc/soapradius/soapradius.conf
sed -i "/MYSQL_PASSWORD=.*/c\\MYSQL_PASSWORD=${AAA_DATABASE_PASSWORD}" /etc/soapradius/soapradius.conf
sed -i "/MYSQL_DATABASE=.*/c\\MYSQL_DATABASE=${AAA_DATABASE_NAME}" /etc/soapradius/soapradius.conf

sed -i "/RABBITMQ_HOSTNAME=.*/c\\RABBITMQ_HOSTNAME=${AAA_RABBITMQ_HOSTNAME}" /etc/soapradius/soapradius.conf
sed -i "/RABBITMQ_PORT=.*/c\\RABBITMQ_PORT=${AAA_RABBITMQ_PORT}" /etc/soapradius/soapradius.conf
sed -i "/RABBITMQ_USERNAME=.*/c\\RABBITMQ_USERNAME=${AAA_RABBITMQ_USERNAME}" /etc/soapradius/soapradius.conf
sed -i "/RABBITMQ_PASSWORD=.*/c\\RABBITMQ_PASSWORD=${AAA_RABBITMQ_PASSWORD}" /etc/soapradius/soapradius.conf
sed -i "/RABBITMQ_EXCHANGE=.*/c\\RABBITMQ_EXCHANGE=${AAA_RABBITMQ_EXCHANGE}" /etc/soapradius/soapradius.conf
sed -i "/RABBITMQ_BINDING_KEY=.*/c\\RABBITMQ_BINDING_KEY=${AAA_RABBITMQ_BINDING_KEY}" /etc/soapradius/soapradius.conf
sed -i "/RABBITMQ_VHOST=.*/c\\RABBITMQ_VHOST=/" /etc/soapradius/soapradius.conf


### Creating log file for Soapradius
[ ! -d /var/log/captiveportal/radius ] && mkdir -p /var/log/captiveportal/radius
[ ! -f /var/log/captiveportal/radius/soapradius.log ] && touch /var/log/captiveportal/radius/soapradius.log
chown syslog.adm /var/log/captiveportal/radius/soapradius.log
