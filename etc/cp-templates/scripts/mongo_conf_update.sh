#!/bin/bash

################################################
####### Updating MongoDB Configuration #########
################################################

### Sourcing captiveportal configuration file
source /etc/captiveportal.conf
#source /etc/captiveportal/conf.d/mongodb-server.conf

function render_template() {
  eval "echo \"$(cat $1)\""
}

#### Creating /etc/mongod.conf from template /etc/cp-templates/mongo/mongod.conf.tmpl
render_template /etc/cp-templates/mongo/mongod.conf.tmpl > /etc/mongod.conf