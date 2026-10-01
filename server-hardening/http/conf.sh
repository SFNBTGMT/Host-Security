cat << 'EOF' | sudo tee /etc/nginx/sites-available/demo > /dev/null
server {
    listen 80;
    server_name sso.demo.local;
    root /var/www/monapp;
    index index.html;

    # Racine : Si pas de cookie, on affiche le login
    location / {
        if ($http_cookie !~* "PHPSESSID") {
            rewrite ^ /login.php last;
        }
        try_files $uri $uri/ /index.html;
    }

    #  Autorise l'accès direct au fichier login.php
    location = /login.php {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }

    #  Traitement standard des autres scripts PHP
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    }
    #  Interception du POST pour Lynx (Évite l'erreur 403 / 405)
    error_page 403 405 =200 @post_to_php;
    location @post_to_php {
        rewrite ^ /login.php last;
    }
    #  Sécurité : Interdire l'accès direct à la liste des mots de passe
    location = /users.txt {
        deny all;
        return 404;
    }
}

}
EOF
# sudo systemctl restart nginx
# sudo nginx -t
