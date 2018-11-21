#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo a2ensite default-ssl
sudo a2enmod ssl
sudo service apache2 restart
echo '<!doctype html><html><body><h1>Welcome To Apache Server Instance</h1></body></html>' | sudo tee /var/www/html/index.html