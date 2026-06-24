#!/bin/bash
set -euxo pipefail

# --- Web tier bootstrap (Nginx + React build) on Amazon Linux 2023 ---

dnf update -y
dnf install -y nginx

# Pull the pre-built React app from S3 (expects web-tier/build/ uploaded to the bucket)
mkdir -p /home/ec2-user/web-tier
aws s3 cp s3://${s3_bucket}/web-tier/ /home/ec2-user/web-tier/ --recursive

# Allow nginx to read the build directory
chmod -R 755 /home/ec2-user

# Render nginx.conf. The internal ALB DNS is injected by templatefile at apply time,
# so a quoted heredoc keeps nginx runtime variables ($uri, $host, ...) literal.
cat > /etc/nginx/nginx.conf <<'NGINX_EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80;
        listen       [::]:80;
        server_name  _;

        # Health check for the external ALB target group
        location /health {
            default_type text/html;
            return 200 "<!DOCTYPE html><p>Web Tier Health Check</p>\n";
        }

        # React app and front end files
        location / {
            root  /home/ec2-user/web-tier/build;
            index index.html index.htm;
            try_files $uri /index.html;
        }

        # Proxy API calls to the internal application load balancer
        location /api/ {
            proxy_pass http://${internal_alb_dns}:80/;
        }
    }
}
NGINX_EOF

systemctl enable nginx
systemctl restart nginx
