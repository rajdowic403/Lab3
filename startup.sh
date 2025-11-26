#!/bin/sh
# W App Service na Linuxie, /bin/sh jest bardziej niezawodny niż /bin/bash

# Nie uruchamiamy "composer install" w skrypcie startowym (bo go nie ma)
# Zamiast tego polegamy na tym, że katalog vendor zostal wgrany (co już zrobiłeś)

# 1. Zapewnienie, że cache Laravela jest czysty przy starcie
# Ta linia rozwiązuje problem z niestabilnością ścieżek widoków
php artisan config:clear

# 2. Ustawienie uprawnień dla storage i cache
chmod -R 777 storage bootstrap/cache

# 3. Kopiowanie niestandardowej konfiguracji NGINX (aby wskazać public/)
# Zastąp domyślną konfigurację App Service
cat > /etc/nginx/sites-enabled/default <<EOF
server {
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
}
EOF

# 4. Restart Nginx
service nginx restart

# 5. Uruchomienie PHP-FPM w tle
echo "INFO: Attempting to start PHP-FPM..." 
/usr/local/sbin/php-fpm -D

# 6. Upewnij się, że działa, zanim przejdziesz do tail -f
echo "INFO: PHP-FPM start command executed. Check Log Stream for FPM errors."

# 6. Utrzymanie skryptu w działaniu, aby kontener nie został zatrzymany
tail -f /dev/null