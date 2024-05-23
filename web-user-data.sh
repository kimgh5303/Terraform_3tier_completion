#!/bin/bash
# Amazon Linux 2 userdata script for setting up Nginx with ProxyPass

bash

# Update packages
sudo yum update -y

# Install Nginx
sudo yum install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure ProxyPass in Nginx
cat << EOF > /etc/nginx/conf.d/proxy.conf
server {
    listen 80;
    server_name web.mycomet.link;

    # Proxy path configuration (e.g., /app)
    location /app {
        proxy_pass http://${alb_dns}/;
    }

    # Log settings (optional)
    error_log /var/log/nginx/mark_error.log;
    access_log /var/log/nginx/mark_access.log combined;
}

server {
    listen 443;
    server_name web.mycomet.link;

    # Proxy path configuration (e.g., /app)
    location /app {
        proxy_pass http://${alb_dns}/;
    }

    # Log settings (optional)
    error_log /var/log/nginx/mark_error.log;
    access_log /var/log/nginx/mark_access.log combined;
}
EOF

RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)


cat << EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Web Server</title>
</head>
<body>
<h1>RegionAz(\$RZAZ) : Instance ID(\$IID) : Private IP(\$LIP) : Web Server</h1>
</body>
</html>
EOF

# Restart Nginx to apply changes
sudo systemctl restart nginx
