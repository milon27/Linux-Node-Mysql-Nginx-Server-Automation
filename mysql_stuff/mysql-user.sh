#!/usr/bin/bash

#make sure run this as sudo bash mysql-user.sh

echo "Creating MySQL user & DB"

USER="db_user"
PASS="db_user_password"
DB="db_name"


mysql -u root <<MYSQL_SCRIPT
CREATE USER '$USER'@'%' identified WITH mysql_native_password by '$PASS';
GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%';
flush privileges;
create database $DB;
MYSQL_SCRIPT


echo "MySQL user&Db created."
echo "Username:   $USER"
echo "Password:   $PASS"
echo "database:   $DB"