#!/bin/bash

################################################
####### Updating Web Server Configuration #######
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf

function render_template() {
  eval "echo \"$(cat $1)\""
}

### Configuring Web server in distribution mode (i.e Running only Web/Splash server in instance)
if [[ ${RUN_WEB_SERVER} -eq 1 && ${RUN_APP_SERVER} -eq 0 ]]; then

	render_template /etc/cp-templates/web/envvars.tmpl > /etc/apache2/envvars
	render_template /etc/cp-templates/web/apache2.conf.tmpl > /etc/apache2/apache2.conf
	render_template /etc/cp-templates/web/distributed-web-ports.conf.tmpl > /etc/apache2/ports.conf	
	render_template /etc/cp-templates/web/security.conf.tmpl > /etc/apache2/conf-enabled/security.conf
	render_template /etc/cp-templates/web/distributed-web-000-default.conf.tmpl > /etc/apache2/sites-enabled/000-default.conf
	render_template /etc/cp-templates/web/distributed-web-default-ssl.conf.tmpl > /etc/apache2/sites-enabled/default-ssl.conf

### Configuring Web server in distribution mode (i.e Running Web server in App server to run Ruby application)
elif [[ ${RUN_WEB_SERVER} -eq 0 && ${RUN_APP_SERVER} -eq 1 ]]; then

	render_template /etc/cp-templates/web/envvars.tmpl > /etc/apache2/envvars
	render_template /etc/cp-templates/web/apache2.conf.tmpl > /etc/apache2/apache2.conf
	render_template /etc/cp-templates/web/distributed-webapp-ports.conf.tmpl > /etc/apache2/ports.conf	
	render_template /etc/cp-templates/web/security.conf.tmpl > /etc/apache2/conf-enabled/security.conf
	render_template /etc/cp-templates/web/distributed-webapp-000-default.conf.tmpl > /etc/apache2/sites-enabled/000-default.conf
	render_template /etc/cp-templates/web/distributed-webapp-default-ssl.conf.tmpl > /etc/apache2/sites-enabled/default-ssl.conf

### Configuring Web server in standalone mode (i.e Running both Web/Splash & App servers in same instance)
elif [[ ${RUN_WEB_SERVER} -eq 1 && ${RUN_APP_SERVER} -eq 1 ]]; then

	render_template /etc/cp-templates/web/envvars.tmpl > /etc/apache2/envvars
	render_template /etc/cp-templates/web/apache2.conf.tmpl > /etc/apache2/apache2.conf
	render_template /etc/cp-templates/web/standalone-ports.conf.tmpl > /etc/apache2/ports.conf
	render_template /etc/cp-templates/web/splash_page_server.conf.tmpl > /etc/splash_page_server.conf
	render_template /etc/cp-templates/web/security.conf.tmpl > /etc/apache2/conf-enabled/security.conf
	render_template /etc/cp-templates/web/standalone-000-default.conf.tmpl > /etc/apache2/sites-enabled/000-default.conf
	render_template /etc/cp-templates/web/standalone-default-ssl.conf.tmpl > /etc/apache2/sites-enabled/default-ssl.conf

fi

if [ -z "$WEB_SSL_CHAIN_CERT_FILE_PATH" ]; then
	sed -i "/SSLCertificateChainFile.*/c\\                \#SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt" /etc/apache2/sites-enabled/default-ssl.conf
fi


### Updating Splashpage Server configuration file
sed -i "/APP_URL.*/c\\APP_URL=${WEB_APP_SERVER_URL}" /etc/splash_page_server.conf

sed -i "/RABBITMQ_HOSTNAME.*/c\\RABBITMQ_HOSTNAME=${WEB_RABBITMQ_HOSTNAME}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_PORT=.*/c\\RABBITMQ_PORT=${WEB_RABBITMQ_PORT}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_USERNAME=.*/c\\RABBITMQ_USERNAME=${WEB_RABBITMQ_USERNAME}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_PASSWORD=.*/c\\RABBITMQ_PASSWORD=${WEB_RABBITMQ_PASSWORD}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_EXCHANGE=.*/c\\RABBITMQ_EXCHANGE=${WEB_RABBITMQ_EXCHANGE}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_BINDING_KEY=.*/c\\RABBITMQ_BINDING_KEY=${WEB_RABBITMQ_BINDING_KEY}" /etc/splash_page_server.conf
sed -i "/RABBITMQ_VHOST=.*/c\\RABBITMQ_VHOST=/" /etc/splash_page_server.conf

#sed -i "s/ServerTokens\ OS/ServerTokens\ Prod/g" /etc/apache2/conf-enabled/security.conf
#sed -i "s/ServerSignature\ On/ServerSignature\ Off/g" /etc/apache2/conf-enabled/security.conf

### Creating log file for Web Server
[ ! -d /var/log/captiveportal/web ] && mkdir -p /var/log/captiveportal/web
chown -R root.adm /var/log/captiveportal/web
[ ! -f /var/log/captiveportal/web/splashsever.log ] && touch /var/log/captiveportal/web/splashserver.log
chown syslog.adm /var/log/captiveportal/web/splashsever.log
