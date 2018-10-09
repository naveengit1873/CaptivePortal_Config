#!/bin/bash

################################################
####### Updating RabbitMQ Configuration #########
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf

#function render_template() {
#  eval "echo \"$(cat $1)\""
#}

#### Creating /etc/rabbitmq/rabbitmq-env.conf from template /etc/cp-templates/rabbitmq/rabbitmq-env.conf.tmpl
#render_template /etc/cp-templates/rabbitmq/rabbitmq-env.conf.tmpl > /etc/rabbitmq/rabbitmq-env.conf

sed -i "/NODE_IP_ADDRESS=.*/c\\NODE_IP_ADDRESS=${RABBITMQ_BIND_IP}" /etc/rabbitmq/rabbitmq-env.conf
sed -i "/NODE_PORT=.*/c\\NODE_PORT=${RABBITMQ_BIND_PORT}" /etc/rabbitmq/rabbitmq-env.conf