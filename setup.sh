#########################
# Variable
##########################

USERNAME="milon27"
PASSWORD="yourPassWd123!@#"
HOEM_DIR="/home/$USERNAME"

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
# usermod -aG sudo milon27

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
sudo systemctl restart mysql

# create a mysql user later .

#6. install pm2
sudo npm install pm2@latest -g

#7. install nginx
sudo apt install nginx

#8. install ssl certbot & python3
sudo apt install certbot python3-certbot-nginx

# other things to do.
  # - create a mysql user later .
  # - setup domain .
  # - create sub domain if you want .
  # - setup ssl .