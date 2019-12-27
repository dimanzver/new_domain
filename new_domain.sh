index=$(($(grep -c -e "^127.0.0." /etc/hosts)+1))
#cd /var/www
mkdir -p /var/www/$2
#cd /etc/apache2/sites-available
sudo sh -c "echo '<Directory /var/www/$2>\nAllowOverride All\n</Directory>\n\n<VirtualHost 127.0.0.$index:81>\nServerName $1\nDocumentRoot /var/www/$2/\n</VirtualHost>'>>/etc/apache2/sites-available/$1.conf"
sudo sh -c "echo '127.0.0.$index $1'>>/etc/hosts"
sudo a2ensite $1
sudo systemctl reload apache2
sudo chown -c www-data:www-data /var/www/$2
sudo chmod -c -R 775 /var/www/$2


#for nginx
nginx_content=$(cat template)
nginx_content=$(echo "$nginx_content" | sed "s/{{IP}}/127.0.0.$index/" | sed "s/{{DIR}}/$2/" | sed "s/{{NAME}}/$1/g")
sudo sh -c "echo '$nginx_content'>/etc/nginx/sites-available/$1"
sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
sudo systemctl restart nginx
