#!/bin/bash

if [ ! -f "/etc/nginx/conf.d/${DOMAIN}.conf" ]; then

        TEMP_FILE="/etc/nginx/conf.d/${DOMAIN}.conf"
                cat > "$TEMP_FILE" <<-EOL
                        server {
                        server_name www.$DOMAIN;
                        access_log /var/wwwlogs/access_www.$DOMAIN;
                        error_log /var/wwwlogs/error_www.$DOMAIN;
                        root /tmp/bedrock-on-heroku/web;
                        set_real_ip_from  10.1.0.1;
                        real_ip_header    X-Forwarded-For;

                        location / {
                        index index.html index.htm index.php;
                        }

                        location ~ \.php\$ {
                                include /etc/nginx/fastcgi_params;
                                fastcgi_pass unix:/var/run/php5-fpm.sock;
                                fastcgi_index index.php;
                                fastcgi_param SCRIPT_FILENAME /tmp/bedrock-on-heroku/web\$fastcgi_script_name;
                        }
                        }
                EOL

    configure_nginx
    /usr/sbin/php5-fpm -D && exec /usr/sbin/nginx -g "daemon off;"
else
    /usr/sbin/php5-fpm -D && exec /usr/sbin/nginx -g "daemon off;"
fi
