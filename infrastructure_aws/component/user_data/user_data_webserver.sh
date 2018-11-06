#!/bin/bash
yum install httpd -y
echo "Welcome to EC2 Instance Web Server" > /var/www/html/index.html
yum update -y
service httpd start