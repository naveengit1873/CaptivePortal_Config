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


#### Creating AAA server config files from templates available at /etc/cp-templates/aaa
#render_template /etc/cp-templates/aaa/radiusd.tmpl > /root/scripts/radiusd
render_template /etc/cp-templates/aaa/phc_server_url.tmpl > /etc/phcconfig/phc_server_url
render_template /etc/cp-templates/aaa/rest.tmpl > /usr/local/etc/raddb/mods-available/rest
render_template /etc/cp-templates/aaa/radiusd.conf.tmpl > /usr/local/etc/raddb/radiusd.conf
render_template /etc/cp-templates/aaa/default.tmpl > /usr/local/etc/raddb/sites-available/default

### Creating log dir for Radius
[ ! -d /var/log/captiveportal/radius ] && mkdir -p /var/log/captiveportal/radius
