index=$(($(grep -c -e "^127.0.0." /etc/hosts)+1))
mkdir -p /var/www/$2
###sudo sh -c "echo '<Directory /var/www/$2>\nAllowOverride All\n</Directory>\n\n<VirtualHost 127.0.0.$index:81>\nServerName $1\nDocumentRoot /var/www/$2/\n</VirtualHost>'>/etc/httpd/sites-available/$1.conf"
sudo sh -c "echo '127.0.0.$index $1'>>/etc/hosts"
###sudo a2ensite $1

apache_content=$(cat $(dirname $0)/template_apache)
apache_content=$(echo "$apache_content" | sed "s/{{IP}}/127.0.0.$index/" | sed "s/{{DIR}}/$2/" | sed "s/{{NAME}}/$1/g")
sudo sh -c "echo '$apache_content'>/etc/httpd/sites-available/$1.conf"

sudo systemctl restart httpd
sudo chown -c www-data:www-data /var/www/$2
sudo chmod -c -R 775 /var/www/$2


#for nginx
nginx_content=$(cat $(dirname $0)/template)
nginx_content=$(echo "$nginx_content" | sed "s/{{IP}}/127.0.0.$index/" | sed "s/{{DIR}}/$2/" | sed "s/{{NAME}}/$1/g")
sudo sh -c "echo '$nginx_content'>/etc/nginx/conf.d/$1.conf"
###sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
sudo systemctl restart nginx
