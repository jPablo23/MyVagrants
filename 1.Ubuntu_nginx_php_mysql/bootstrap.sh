#!/bin/bash

# Using single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='html'

# create project folder
sudo mkdir "/var/www/${PROJECTFOLDER}"

# update / upgrade
echo "Updating apt-get..."
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y upgrade > /dev/null 2>&1

# install nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx > /dev/null 2>&1

# install php7-fpm
echo "Installing PHP..."
sudo apt-get install -y php-fpm php-mysql php-xml php-gd php-curl > /dev/null 2>&1

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"

echo "Installing MySQL..."
sudo apt-get install -y mysql-server > /dev/null

echo "Updating apt-get..."
sudo apt-get update > /dev/null 2>&1

# NodeJS and cURL
echo "NodeJS and cURL."
sudo apt-get -y install nodejs 2>&1
sudo apt-get -y install curl 2>&1
 
# Nginx Config
echo "Configuring Nginx..."
sudo cp /var/www/config/nginx_vhost /etc/nginx/sites-available/nginx_vhost > /dev/null 2>&1
sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/

sudo rm -rf /etc/nginx/sites-enabled/default

sudo cat > /etc/nginx/sites-available/nginx_vhost <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name localhost;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Restarting Nginx for config to take effect
echo "Restarting Nginx..."
sudo service nginx restart > /dev/null 2>&1
sudo service mysql restart > /dev/null 2>&1