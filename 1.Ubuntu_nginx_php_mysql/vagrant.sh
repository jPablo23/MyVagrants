#!/usr/bin/env bash
# Vagrant provisioning

# update / upgrade
echo "Updating apt-get..."
export DEBIAN_FRONTEND="noninteractive";
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y upgrade > /dev/null 2>&1
sudo apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common unzip

# install git
echo "Installing Git..."
sudo apt-get install -y git > /dev/null 2>&1

# install nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx > /dev/null 2>&1
sudo service nginx start

# Nginx Configuration
echo "Configuring Nginx..."
sudo bash -c "cat <<-'EOF' > /etc/nginx/sites-available/project
# Simple NGINX Dev virtual server setup
# this is copied automatically via Vagrant during provisioning
server {
        listen 8080;
        listen [::]:8080;
        root /var/www/html/public;
        index index.php index.html index.htm index.nginx-debian.html;
        # Important for VirtualBox
        sendfile off;
        server_name localhost;
        client_max_body_size 10M;
        location /phpmyadmin {
            root /usr/share/;
            index index.php index.html index.htm;
            location ~ ^/phpmyadmin/(.+\.php)$ {
                try_files \$uri =404;
                root /usr/share/;
                fastcgi_pass unix:/run/php/php8.0-fpm.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                include /etc/nginx/fastcgi_params;
            }
            location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
                root /usr/share/;
            }
        }
        location / {
                try_files \$uri \$uri/ /index.php\$is_args\$args;
        }
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                # With php-fpm:
                fastcgi_pass unix:/run/php/php8.0-fpm.sock;
        }
        error_page 404 /index.php;
        location ~ /\. {
                deny all;
        }
}
EOF"

sudo ln -sf /etc/nginx/sites-available/project /etc/nginx/sites-enabled/
sudo rm -rf /etc/nginx/sites-available/default
sudo rm -rf /etc/nginx/sites-enabled/default
sudo service nginx restart

# install MySQL
echo "Installing MySQL8..."
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
wget https://dev.mysql.com/get/mysql-apt-config_0.8.10-1_all.deb
sudo -E dpkg -i mysql-apt-config_0.8.10-1_all.deb
sudo apt-get update
sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password root'
sudo debconf-set-selections <<< 'myvsql-community-server mysql-community-server/root-pass password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y mysql-server mysql-client

# Override any existing bind-address to be 0.0.0.0 to accept connections from host
echo "Updating my.cnf..."
sudo sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf
echo "[mysqld]" | sudo tee -a /etc/mysql/my.cnf
echo "bind-address=0.0.0.0" | sudo tee -a /etc/mysql/my.cnf
echo "default-time-zone='+00:00'" | sudo tee -a /etc/mysql/my.cnf

# Create client database
mysql -u root -proot -e "CREATE DATABASE project;"

# Grant root access
echo "Granting root access via any IP..."
MYSQL_PWD=root mysql -u root -e "CREATE USER 'root'@'%' IDENTIFIED BY 'root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES; SET GLOBAL max_connect_errors=10000;"

# Start MySQL server
echo "Restarting MySQL..."
sudo service mysql restart

# Install PMA
echo "Installing PMA..."
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
sudo apt-get -y install phpmyadmin

# Upgrade PMA
sudo rm -rf /usr/share/phpmyadmin
sudo wget -P /usr/share/ "https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-english.zip"
sudo unzip /usr/share/phpMyAdmin-5.1.1-english.zip -d /usr/share/
sudo cp -r /usr/share/phpMyAdmin-5.1.1-english /usr/share/phpmyadmin
sudo rm -rf /usr/share/phpMyAdmin-5.1.1-english.zip

# Setup PMA
cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
echo "\$cfg['blowfish_secret'] = 'gvSe[zE,Pn7D0t-sM9;n4v1CB,tCD6W.';" | sudo sed -i "" /usr/share/phpmyadmin/config.inc.php
sudo mkdir /usr/share/phpmyadmin/tmp
sudo chown -R www-data:www-data /usr/share/phpmyadmin/tmps

# install PHP
echo "Installing PHP8..."
sudo apt-add-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install -y --allow-change-held-packages \
  php8.0 php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-cli php8.0-common php8.0-curl php8.0-dba php8.0-dev \
  php8.0-enchant php8.0-fpm php8.0-gd php8.0-gmp php8.0-imap php8.0-interbase php8.0-intl php8.0-ldap \
  php8.0-mbstring php8.0-mysql php8.0-odbc php8.0-opcache php8.0-pgsql php8.0-phpdbg php8.0-pspell php8.0-readline \
  php8.0-snmp php8.0-soap php8.0-sqlite3 php8.0-sybase php8.0-tidy php8.0-xdebug php8.0-xml php8.0-xsl php8.0-zip \
  php8.0-memcached

update-alternatives --set php /usr/bin/php8.0
update-alternatives --set php-config /usr/bin/php-config8.0
update-alternatives --set phpize /usr/bin/phpize8.0

# Install composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Reload
sudo rm -rf /var/www/html/index.nginx-debian.html
sudo service php8.0-fpm start
sudo service nginx reload