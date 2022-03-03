# Linux-Node-Mysql-Nginx-Server-Automation


- run setup.sh
- check after-setup.txt file.


> finally ck all the steps are done or not.
  1. check all-setps-shortcut.txt file

> some helper file.
  1. for nginx server setup [nginx-server-block.txt]

---
> note: if you are using oracle [enable port 80]

```
sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
sudo netfilter-persistent save
```

> note 2 : certbot
```
show all cert: sudo certbot certificates
delete a cert: sudo certbot delete --cert-name about.app.com
now remove all code from nginx server block 
```

> note 3 : mysql sql-mode issue
```
temporary solution:
-- form : ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
-- to 
set global sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

```

```
permanent solution:
: edit: sudo nano /etc/mysql/my.cnf
:paste this
[mysqld]
sql-mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"

:restart:

sudo service mysql stop
sudo service mysql start
sudo systemctl restart mysql


```



