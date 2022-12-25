#!/bin/bash
sudo apt-get update -y
sudo apt install -y apache2

sudo mkdir -p /var/www/html/
sudo echo "<h2>GCP lamp by sparrow<h2>" > /var/www/html/index.html

sudo apt install -y mariadb-server
sudo apt install -y php libapache2-mod-php php-mysql
sudo touch /var/www/html/phpinfo.php
cat <<EOF > /var/www/html/phpinfo.php
 <?php phpinfo(); ?>
EOF
sudo service apache2 restart
