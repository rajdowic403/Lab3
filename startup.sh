!/bin/bash
# Zainstalowanie zależności Laravela
composer install --no-dev --prefer-dist
php artisan config:clear
# Uruchomienie migracji (ostrożnie! --force jest dozwolone tylko w środowisku non-interactive)
# php artisan migrate --force

# Konfiguracja NGINX, aby wskazywał na public/
# Tworzenie niestandardowego pliku konfiguracyjnego NGINX
echo "server {
    listen 8080;
    root /home/site/wwwroot/public;
    index index.php index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
    }
}" > /etc/nginx/sites-enabled/default
    

service nginx restart



tail -f /dev/null