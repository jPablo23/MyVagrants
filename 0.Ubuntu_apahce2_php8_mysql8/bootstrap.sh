#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='myproject'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
echo "Updating apt-get..."
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
echo "Installing PHP..."
sudo apt-get install -y apache2
sudo apt-get install -y php8.0 php8.0-cli php8.0-common php8.0-mbstring php8.0-intl php8.0-xml php8.0-mcrypt  php8.1-intl
sudo apt-get install -y libapache2-mod-php8.0

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php8.0-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
echo "Installing MySQL..."
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
echo "setup hosts file..."
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/${PROJECTFOLDER}"
    <Directory "/var/www/html/${PROJECTFOLDER}">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite



# install git
#sudo apt-get -y install git

# install NodeJS, NPM and cURL
echo "NodeJS and cURL."
sudo apt-get -y install nodejs
sudo apt-get -y install npm 
sudo apt-get -y install curl 

# install Composer
echo "install Composer."
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# list Versions
echo "list Versions."
echo "======>XDDD<========"
node -v
npm -v
composer -v
mysql -V
# list Versions
echo "Restart Services"
# restart apache
echo "restart apache..."
sudo service apache2 restart
echo "======>===<========="
echo "======>===<========="
echo "======>===<========="
echo "======>===<========="
echo "======>===<========="
echo "======>FIN<========="


