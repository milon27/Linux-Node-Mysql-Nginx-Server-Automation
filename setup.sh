#!/usr/bin/bash
#########################
# Variable
##########################

USERNAME="new_user_name"
PASSWORD="new_user_password"
HOEM_DIR="/home/$USERNAME"

#mysql db variable
USER="db_user"
PASS="db_user_password"
DB="db_name"


########################
# Start Setup
########################
# update & upgrade

apt update
apt dist-upgrade


echo "creating a sudo user"

#1 enable auto update
#dpkg-reconfigure --priority=low unattended-upgrades

#2 create a user
useradd -m -p $(openssl passwd -1 "$PASSWORD") -s /bin/bash -G sudo "$USERNAME"

#2.1 append sudo group
# usermod -aG sudo "$USERNAME"

#3 create .ssh and cp the pub.key
cd $HOEM_DIR && mkdir "$HOEM_DIR/.ssh" && chmod 700 "$HOEM_DIR/.ssh"
cp /root/.ssh/authorized_keys "$HOEM_DIR/.ssh"
sudo chown "$USERNAME":"$USERNAME" .ssh

#  remove password login (will do later)
sudo nano /etc/ssh/sshd_config
# *. permitRootLogin yes -> no
# *. passwordAuthentication yes->no


########################
# Start Installation
########################
echo "start installing packages"

#4 install node js
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

#5 install mysql-server
sudo apt install mysql-server
sudo mysql_secure_installation

#5.1 edit mysql conf file
echo "edit mysql conf file to change (change port to ramdom e.g. 5063+ )"
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
#5.1.1 //change default port to something random (more than 1080)=5033

#5.1.2 //change from where to access the database [127.0.0.1=localhost]
# 	bind-address=0.0.0.0 (from anywhere)
# 	mysqlx-bind-address=0.0.0.0 (from anywhere)

sudo systemctl restart mysql

#5.2 create a mysql user & database .

sudo mysql -u root <<MYSQL_SCRIPT
CREATE USER '$USER'@'%' identified WITH mysql_native_password by '$PASS';
GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%';
flush privileges;
create database $DB;
MYSQL_SCRIPT
echo "MySQL user&Db created."


#6. install pm2
sudo npm install pm2@latest -g

#7. install nginx
sudo apt install nginx

#8. install ssl certbot & python3
sudo apt install certbot python3-certbot-nginx

# other things to do.
  # - setup domain .
  # - create sub domain if you want .
  # - setup ssl .