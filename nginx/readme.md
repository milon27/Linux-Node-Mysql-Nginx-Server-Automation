- first install nginx
```
sudo apt installl nginx
# or
sudo yum install nginx
``` 

- check the status 
``` 
sudo systemctl status nginx
````
- start nginx  
``` 
sudo systemctl start nginx 
````
- create a new file on /site-enabled or /conf.d directory 
```
# in site enabled dir any name can be as filename without any extension
touch myserver
# in conf.d directory file name must have [name].conf extention
touch myserver.conf
```

- content of myserver or myserver.conf
```
# for server reverse proxy
server {
    # root /var/www/blog.example.com;
    # index index.html;
    server_name _;
    location / {
       proxy_pass http://localhost:2727/;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    listen [::]:80;
    listen 80;
}

# for staic site
server {
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name example.com;

        location / {
             try_files $uri $uri/ =404; # simple html app
             #try_files $uri /index.html; # react js app/single page app
        }
}

```

- test nginx config
```
sudo nginx -t
```

- restart nginx
```
sudo systemctl restart nginx
```

