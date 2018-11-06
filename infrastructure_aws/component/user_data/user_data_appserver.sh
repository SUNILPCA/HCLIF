#!/bin/bash
yum update -y
yum install java-1.8.0 -y
yum install tomcat8 tomcat8-webapps tomcat8-admin-webapps tomcat8-docs-webapp -y
cd /usr/share/tomcat8
service tomcat8 start