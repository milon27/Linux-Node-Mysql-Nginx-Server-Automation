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
