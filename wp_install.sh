#!/bin/bash


install_wordpress_docker ()
{


# Quastions for the docker file
# create a new docker Wordpress

echo 'Would you like to install Docker WordPress on your Server?'
echo 'Please, answer following quastions:'
echo 'Please add the subdomain or www as the first variable.'
read -e subdomain
echo 'Please add the main domain as second variable, ex: google.com'
read -e domain
echo 'Plaese add the admin user for the wordpress backend, ex: AdminWP'
read -e admin_user
echo 'Plaese set the admin password for the wordpress backend.'
read -e admin_pass
echo 'Please add the main e-mail adress for LETSENCRYPT_EMAIL, ex: username@domainname.com'
read -e emailadress
echo 'Please add the SMTP Mail UserID for WP Mail SMTP config, ex: username@domainname.com'
read -e WPMS_SMTP_USER
echo 'Please add the SMTP Mail password for WP Mail SMTP config, ex: username@domainname.com'
read -e WPMS_SMTP_PASSWORD
echo 'Please add the SMTP server, ex: smtp.strato.de'
read -e WPMS_SMTP_SERVER


#read -e emailadress
echo 'I got the following info for the setup your Wordpress:'
echo 'URL will be: '$subdomain.$domain
echo 'LETSENCRYPT_EMAIL: '$emailadress
echo 'SMTP Password: '$WPMS_SMTP_PASSWORD
echo ''

read -p "Continuing in 1 Seconds...." -t 1

echo ''
echo ''




mkdir ~/wordpress_$subdomain.$domain && cd ~/wordpress_$subdomain.$domain

PASSROOT=`pwgen -s 40 1`

PASSMYSQL=`pwgen -s 40 1`

touch .env
echo 'NETWORK=nginx-proxy'  >> .env
echo 'CONTAINER_DB_NAME=wp_'$subdomain.$domain'_db' >> .env
echo 'MYSQL_ROOT_PASSWORD='$PASSROOT >> .env
echo 'MYSQL_DATABASE=db'$subdomain >> .env
echo 'MYSQL_USER=user'$subdomain >> .env
echo 'MYSQL_PASSWORD='$PASSMYSQL >> .env
echo 'LETSENCRYPT_EMAIL='$emailadress >> .env
echo 'DOMAINS='$subdomain.$domain >> .env
echo 'WORDPRESS_DB_HOST=db_node_'$subdomain.$domain':3306' >> .env
echo 'CONTAINER_WP_NAME=wp_'$subdomain.$domain >> .env
echo '------------ WP Mail SMTP config -------------------' >> .env
echo 'WPMS_SMTP_USER='$WPMS_SMTP_USER >> .env
echo 'WPMS_SMTP_SERVER='$WPMS_SMTP_SERVER >> .env 
echo 'WPMS_SMTP_PASS='$WPMS_SMTP_PASSWORD >> .env

touch docker-compose.yml

echo 'version: "3"' >> docker-compose.yml
echo '' >> docker-compose.yml
echo 'services:' >> docker-compose.yml
echo '   db_node_'$subdomain.$domain':' >> docker-compose.yml
echo '     image: mariadb:latest' >> docker-compose.yml
echo '     volumes:' >> docker-compose.yml
echo '        - db_data:/var/lib/mysql' >> docker-compose.yml
echo '     restart: always' >> docker-compose.yml
echo '     environment:' >> docker-compose.yml
echo '        MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}' >> docker-compose.yml
echo '        MYSQL_DATABASE: ${MYSQL_DATABASE}' >> docker-compose.yml
echo '        MYSQL_USER: ${MYSQL_USER}' >> docker-compose.yml
echo '        MYSQL_PASSWORD: ${MYSQL_PASSWORD}' >> docker-compose.yml
echo '     container_name: ${CONTAINER_DB_NAME}' >> docker-compose.yml
echo '' >> docker-compose.yml
echo '   wordpress:' >> docker-compose.yml
echo '     depends_on:' >> docker-compose.yml
echo '        - db_node_'$subdomain.$domain >> docker-compose.yml
echo '     image: wordpress:latest' >> docker-compose.yml
echo '     volumes:' >> docker-compose.yml
echo '        - ./'$subdomain.$domain'/:/var/www/html' >> docker-compose.yml
echo '     expose:' >> docker-compose.yml
echo '        - 80' >> docker-compose.yml
echo '     restart: always' >> docker-compose.yml
echo '     environment:' >> docker-compose.yml
echo '        VIRTUAL_HOST: ${DOMAINS}' >> docker-compose.yml
echo '        LETSENCRYPT_HOST: ${DOMAINS}' >> docker-compose.yml
echo '        LETSENCRYPT_EMAIL: ${LETSENCRYPT_EMAIL}' >> docker-compose.yml
echo '        WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}' >> docker-compose.yml
echo '        WORDPRESS_DB_USER: ${MYSQL_USER}' >> docker-compose.yml
echo '        WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}' >> docker-compose.yml
echo '        WORDPRESS_DB_NAME: ${MYSQL_DATABASE}' >> docker-compose.yml
echo '        WORDPRESS_CONFIG_EXTRA='
echo '           define( 'WPMS_ON', true );'
echo '           define( 'WPMS_SMTP_PASS', ${WPMS_SMTP_PASSWORD} );'
echo '     container_name: ${CONTAINER_WP_NAME}' >> docker-compose.yml
echo ''
echo ''
echo '   wpcli:' >> docker-compose.yml
echo '     image: wordpress:cli' >> docker-compose.yml
echo '     user: xfs' >> docker-compose.yml
echo '    # command: run bash run.sh' >> docker-compose.yml
echo '     volumes:' >> docker-compose.yml
echo '             #        - ./config/php.conf.ini:/usr/local/etc/php/conf.d/conf.ini' >> docker-compose.yml
echo '        - ./'$subdomain.$domain'/:/var/www/html' >> docker-compose.yml
echo '     depends_on:' >> docker-compose.yml
echo '        - db_node_'$subdomain.$domain >> docker-compose.yml
echo '        - wordpress' >> docker-compose.yml
echo ''
echo '' >> docker-compose.yml
echo 'volumes:' >> docker-compose.yml
echo '  db_data:' >> docker-compose.yml
echo '  wordpress:' >> docker-compose.yml
echo '' >> docker-compose.yml
echo 'networks:' >> docker-compose.yml
echo '  default:' >> docker-compose.yml
echo '    external:' >> docker-compose.yml
echo '      name: ${NETWORK}' >> docker-compose.yml

}


wp-core-install ()
{

sleep 20
docker-compose run --rm wpcli core install --url="https://$subdomain.$domain" --title="$subdomain.$domain" --admin_user=$admin_user --admin_password=$admin_pass --admin_email=$emailadress --skip-email
docker-compose run --rm wpcli language core install de_DE
docker-compose run --rm wpcli language core activate de_DE
docker-compose run --rm wpcli  wpcli plugin install wp-mail-smtp --activate
docker-compose run --rm wpcli plugin list >> wp-update.log
docker-compose run --rm wpcli core update >> wp-update.log
docker-compose run --rm wpcli plugin update --all >> wp-update.log
docker-compose run --rm wpcli theme update --all >> wp-update.log
docker-compose run --rm wpcli language core update >> wp-update.log
docker-compose run --rm wpcli language plugin update --all >> wp-update.log

}


wp-update ()
{
cat >> wp-update.sh <<EOL
#!/bin/bash
docker-compose run --rm wpcli plugin list >> wp-update.log
docker-compose run --rm wpcli core update >> wp-update.log
docker-compose run --rm wpcli plugin update --all >> wp-update.log
docker-compose run --rm wpcli theme update --all >> wp-update.log
docker-compose run --rm wpcli language core update >> wp-update.log
docker-compose run --rm wpcli language plugin update --all >> wp-update.log
cat wp-update.log
EOL
chown docker:docker wp-update.sh
chmod +x wp-update.sh
}

echo ''
echo ''
echo '############ Please choose next step ##########'
echo ''
echo 'Please type your answer now: process or exit? '
echo ''
echo "Install Wordpress for Docker, progress pls type 'without' for option without docker up for testing: "
echo ''
echo "Install Wordpress for Docker, progress pls type 'yes' for option with docker up: "
echo ''
echo 'Choose your answer please: ' & read answer
echo ''
echo Answer for the action is: $answer


if [ "$answer" = "yes" ]
then
  install_wordpress_docker

        docker-compose up -d
        sleep 15
        wp-core-install
        wp-update
        ./wp-update.sh
  exit
fi

if [ "$answer" = "without" ]
then
  install_wordpress_docker

    exit
fi
