#!/bin/bash

################################################
####### Updating App Server Configuration #######
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf

function render_template() {
  eval "echo \"$(cat $1)\""
}

### Creating temporary config files from template
cp /etc/cp-templates/app/standalone.xml.tmpl /tmp/standalone.xml
cp /etc/cp-templates/app/manageJBoss.sh.tmpl /tmp/manageJBoss.sh
cp /etc/cp-templates/app/commonFunctions.sh.tmpl /tmp/commonFunctions.sh
cp /etc/cp-templates/app/jboss_installed.properties.tmpl /tmp/jboss_installed.properties

### Configuring App server to distribution mode (i.e Running only App server)
if [[ ${RUN_WEB_SERVER} -eq 0 && ${RUN_APP_SERVER} -eq 1 ]]; then

	### Applying changes to temporary standalone.xml file
	sed -i "s/8080/9080/g" /tmp/standalone.xml
	sed -i "s/8443/9443/g" /tmp/standalone.xml
	sed -i "653s/.*/            \<inet\-address value\=\"\$\{jboss.bind.address.management\:127.0.0.1}\"\/\>/" /tmp/standalone.xml
	sed -i "656s/.*/            \<inet\-address value\=\"\$\{jboss.bind.address\:127.0.0.1}\"\/\>/" /tmp/standalone.xml

	### Applying changes to temporary manageJBoss.sh file
	sed -i "s/8080/9080/g" /tmp/manageJBoss.sh
	sed -i "s/8443/9443/g" /tmp/manageJBoss.sh

	### Applying changes to temporary commonFunctions.sh file
	sed -i "s/8080/9080/g" /tmp/commonFunctions.sh

	### Applying changes to temporary jboss_installed.properties file
	sed -i "s/8080/9080/g" /tmp/jboss_installed.properties
	sed -i "s/8443/9443/g" /tmp/jboss_installed.properties

### Configuring App server to standalone mode (i.e. Runing both App & Web/Splash server in same instance)
elif [[ ${RUN_WEB_SERVER} -eq 1 && ${RUN_APP_SERVER} -eq 1 ]]; then

	### Applying changes to temporary standalone.xml file
	sed -i "s/8080/$APP_SERVER_HTTP_LISTEN_PORT/g" /tmp/standalone.xml
	sed -i "s/8443/$APP_SERVER_HTTPS_LISTEN_PORT/g" /tmp/standalone.xml
	sed -i "653s/.*/            \<inet\-address value\=\"\$\{jboss.bind.address.management\:$APP_SERVER_LISTEN_IP}\"\/\>/" /tmp/standalone.xml
	sed -i "656s/.*/            \<inet\-address value\=\"\$\{jboss.bind.address\:$APP_SERVER_LISTEN_IP}\"\/\>/" /tmp/standalone.xml

	### Applying changes to temporary manageJBoss.sh file
	sed -i "s/8080/$APP_SERVER_HTTP_LISTEN_PORT/g" /tmp/manageJBoss.sh
	sed -i "s/8443/$APP_SERVER_HTTPS_LISTEN_PORT/g" /tmp/manageJBoss.sh

	### Applying changes to temporary commonFunctions.sh file
	sed -i "s/8080/$APP_SERVER_HTTP_LISTEN_PORT/g" /tmp/commonFunctions.sh

	### Applying changes to temporary jboss_installed.properties file
	sed -i "s/8080/$APP_SERVER_HTTP_LISTEN_PORT/g" /tmp/jboss_installed.properties
	sed -i "s/8443/$APP_SERVER_HTTPS_LISTEN_PORT/g" /tmp/jboss_installed.properties

fi

### Updating data source details in standalone.xml file
sed -i "242s/.*/                        \<user-name\>$APP_SERVER_DATABASE_USER\<\/user-name\>/" /tmp/standalone.xml
sed -i "243s/.*/                        \<password\>$APP_SERVER_DATABASE_PASSWORD\<\/password\>/" /tmp/standalone.xml
sed -i "/jdbc:mysql.*/c\\                    <connection-url\>jdbc:mysql:\/\/$APP_SERVER_DATABASE_IP\:$APP_SERVER_DATABASE_PORT\/$APP_SERVER_DATABASE_NAME\<\/connection-url\>" /tmp/standalone.xml

### Copying updated config files
cp /tmp/manageJBoss.sh /u04/jboss/bin/manageJBoss.sh
cp /tmp/commonFunctions.sh /u04/jboss/bin/commonFunctions.sh
cp /tmp/jboss_installed.properties /etc/jboss_installed.properties
cp /tmp/standalone.xml /u04/jboss/standalone/configuration/standalone.xml

### Creating storage directories for DNS, VSA if not exist
[ ! -d /u04/jboss/standalone/data/SaveDNS ] && mkdir -p /u04/jboss/standalone/data/SaveDNS
[ ! -d /u04/jboss/standalone/data/NasIDsDIR ] && mkdir -p /u04/jboss/standalone/data/NasIDsDIR
[ ! -d /u04/jboss/standalone/data/raddic/vRadfiles ] && mkdir -p /u04/jboss/standalone/data/raddic/vRadfiles


### Creating application server config/property files from templates available at /etc/cp-templates/app
render_template /etc/cp-templates/app/standalone.conf.tmpl > /u04/jboss/bin/standalone.conf
render_template /etc/cp-templates/app/jdbc.properties.tmpl > /u04/jboss/standalone/deployments/hns-rest-api.war/WEB-INF/classes/v1/conf/jdbc.properties
render_template /etc/cp-templates/app/ConfigData.properties.tmpl > /u04/jboss/HNSDataProcessing/cfg/ConfigData.properties
render_template /etc/cp-templates/app/Analytics.db.properties.tmpl > /u04/jboss/standalone/deployments/AnalyticsRestApi.war/WEB-INF/classes/db.properties
render_template /etc/cp-templates/app/Analytics.hibernate.cfg.xml.tmpl > /u04/jboss/standalone/deployments/AnalyticsRestApi.war/WEB-INF/classes/hibernate.cfg.xml
render_template /etc/cp-templates/app/CronJOB.db.properties.tmpl > /u04/jboss/standalone/deployments/CronJOB.war/WEB-INF/classes/db.properties
render_template /etc/cp-templates/app/CronJOB.cron-servlet.xml.tmpl > /u04/jboss/standalone/deployments/CronJOB.war/WEB-INF/cron-servlet.xml
render_template /etc/cp-templates/app/CronJOB.hibernate.cfg.xml.tmpl > /u04/jboss/standalone/deployments/CronJOB.war/WEB-INF/classes/hibernate.cfg.xml
render_template /etc/cp-templates/app/OneBox.db.properties.tmpl > /u04/jboss/standalone/deployments/OneBox.war/WEB-INF/classes/db.properties
render_template /etc/cp-templates/app/OneBox.jdbc.properties.tmpl > /u04/jboss/standalone/deployments/OneBox.war/WEB-INF/classes/jdbc.properties
render_template /etc/cp-templates/app/OneBox.hibernate.cfg.xml.tmpl > /u04/jboss/standalone/deployments/OneBox.war/WEB-INF/classes/hibernate.cfg.xml
render_template /etc/cp-templates/app/OneBox.filePaths.properties.tmpl > /u04/jboss/standalone/deployments/OneBox.war/WEB-INF/classes/filePaths.properties
render_template /etc/cp-templates/app/hns-rest-api.addRadiusAccessPoints.properties.tmpl > /u04/jboss/standalone/deployments/hns-rest-api.war/WEB-INF/classes/addRadiusAccessPoints.properties

### Reset owner for Jboss home (/u04/jboss) directory to jboss
chown -R jboss:jboss /u04/jboss > /dev/null 2>&1