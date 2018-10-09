#!/bin/bash

################################################
####### Updating DB Server Configuration #######
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf

#function render_template() {
#  eval "echo \"$(cat $1)\""
#}

#### Creating /etc/mysql/mysql.conf.d/mysqld.cnf from template /etc/cp-templates/db/mysqld.cnf.tmpl
#render_template /etc/cp-templates/db/mysqld.cnf.tmpl > /etc/mysql/mysql.conf.d/mysqld.cnf

sed -i "34s/.*/port		\= ${DATABASE_BIND_PORT}/" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "42s/.*/default-time-zone       \= \'${DATABASE_TIME_ZONE}\'/" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "46s/.*/bind-address		\= ${DATABASE_BIND_IP}/" /etc/mysql/mysql.conf.d/mysqld.cnf

### Creating log file for DB Server
#[ ! -d /var/log/captiveportal/mysql ] && mkdir -p /var/log/captiveportal/mysql
#chown mysql.adm /var/log/captiveportal/mysql
