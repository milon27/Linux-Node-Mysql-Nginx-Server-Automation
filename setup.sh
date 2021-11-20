#!/usr/bin/bash
#########################
# Variable
##########################
TIMEZONE="Asia/Dhaka"

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

#set your local timezone
timedatectl set-timezone $TIMEZONE


echo "creating a sudo user"

#1 enable auto update
dpkg-reconfigure --priority=low unattended-upgrades

#2 create a user
useradd -m -p $(openssl passwd -1 "$PASSWORD") -s /bin/bash -G sudo "$USERNAME"

#2.1 append sudo group
# usermod -aG sudo "$USERNAME"

#3 create .ssh and cp the pub.key
cd $HOEM_DIR && mkdir "$HOEM_DIR/.ssh" && chmod 700 "$HOEM_DIR/.ssh"
cp /root/.ssh/authorized_keys "$HOEM_DIR/.ssh"
sudo chown "$USERNAME":"$USERNAME" .ssh
sudo chown "$USERNAME":"$USERNAME" .ssh/authorized_keys

#  remove password login (will do later)
sudo nano /etc/ssh/sshd_config
# *. permitRootLogin yes -> no
# *. passwordAuthentication yes->no
sudo systemctl restart sshd

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

#create a folder where all mysql backup will store.
mkdir $HOEM_DIR/backup
sudo chown "$USERNAME":"$USERNAME" $HOEM_DIR/backup
#create a folder where mmenv.txt and action-runner will store.
mkdir $HOEM_DIR/application
sudo chown "$USERNAME":"$USERNAME" $HOEM_DIR/application


#6. install pm2
sudo npm install pm2@latest -g

#7. install nginx
sudo apt install nginx

#7.1 make /var/www/html public to upload using scp. (only needed when root login is disabled)
chmod 777 /var/www/html

#8. install ssl certbot & python3
sudo apt install certbot python3-certbot-nginx

# other things to do.
  # - pm2 startup
  # - to remove pm2 startup :  pm2 unstartup systemd
  # - setup domain .
  # - create sub domain if you want .
  # - install ssl .
  # - setup nginx
 
  # - create mmenv.txt file inside ~/applicaiton/mmenv.txt
  # - ci/cid create action-runner inside ~/applicaiton/
  # - api will run on port 2727, setup nginx to reverse proxy
        # - proxy_pass http://localhost:2727;
  # - turn off port 2727 from digital ocean firewall
  # - - ------------------------------------- - -
  # - - ---Transfer db from another droplet (optional)------ - -
  # - - ------------------------------------- - -

  # - setup react + gzip on nginx
  # - upload react files in the /var/www/html folder
  # - enable gzip in nginx[sudo nano /etc/nginx/nginx.conf] -> sudo systemctl restart nginx

  # - add 3 cron tab. certbot, daily db backup, monthly db delete.[after sestup file.txt]
  