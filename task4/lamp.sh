#!/bin/bash
sudo mkdir -p /var/www/html/
sudo echo "<h2>GCP lamp by sparrow<h2>" > /var/www/html/index.html

sudo apt-get update -y
sudo apt-get install apache2 php libapache2-mod-php
sudo apt-get install mariadb-server php php-mysql
sudo apt-get install wget -y
sudo wget https://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo chown -R www-data:www-data /var/www/html/wordpress/
sudo service apache2 restart