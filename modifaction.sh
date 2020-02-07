#!/bin/bash


change_https_redirction_to_http()
{
sed -i 's/return 301 https/return 301 http/g' /home/docker/nginx-proxy/nginx.tmpl
cd /home/docker/nginx-proxy/
docker-compose up -d --force-recreate nginx
cat /home/docker/nginx-proxy/nginx.tmpl | grep 'return 301 http'
}

change_http_redirction_to_https()
{
sed -i 's/return 301 http/return 301 https/g' /home/docker/nginx-proxy/nginx.tmpl
cd /home/docker/nginx-proxy/
docker-compose up -d --force-recreate nginx
cat /home/docker/nginx-proxy/nginx.tmpl | grep 'return 301 http'
}

disable_the_certbotstg_to_prod()
{
cd /home/docker/nginx-proxy/
sed -i 's/ACME_CA_URI/#ACME_CA_URI/g' /home/docker/nginx-proxy/docker-compose.yml
docker-compose up -d --force-recreate letsencrypt
cat /home/docker/nginx-proxy/docker-compose.yml | grep 'ACME_CA_URI'
}

disable_the_certbotprod_to_stg()
{
cd /home/docker/nginx-proxy/
sed -i 's/#ACME_CA_URI/ACME_CA_URI/g' /home/docker/nginx-proxy/docker-compose.yml
docker-compose up -d --force-recreate letsencrypt
cat /home/docker/nginx-proxy/docker-compose.yml | grep 'ACME_CA_URI'
}




extra_nginx_enable_prod_certbot_10_action()
{
su - docker
sed -i 's/ACME_CA_URI/#ACME_CA_URI/g' /home/docker/nginx-proxy/docker-compose.yml
cd /home/docker/nginx-proxy/
docker-compose up -d --force-recreate letsencrypt
cat /home/docker/nginx-proxy/docker-compose.yml | grep 'ACME_CA_URI'
exit
}

#-------------------------------
if [ "$answer" = "5" ]
then echo Exit program
        fi

if [ "$answer" = "1" ]
then
chmod +x /root/docker/install_server.sh
cp /root/docker/check.sh /home/docker/.
chmod +x /home/docker/check.sh
/root/docker/./install_server.sh

exit
        fi


if [ "$answer" = "2" ]
then
install_docker_5_action
modify_docker_6_action
install_docker_composer_7_action
start_docker_network_8
extra_nginx_enable_prod_certbot_10_action
cat /home/docker/nginx-proxy/docker-compose.yml | grep 'ACME_CA_URI'
exit
        fi

        if [ "$answer" = "2.1" ]
        then
          start_docker_network_8
          extra_nginx_enable_prod_certbot_10_action
        exit
                fi


if [ "$answer" = "3" ]
then
        echo "Install Wordpress for Docker"
        cp /home/docker/docker/install_wp.sh .
        chmod +x /home/docker/install_wp.sh
        /home/docker/./install_wp.sh
        exit
        fi


if [ "$answer" = "4" ]
then
        echo "Install Nextcloud for Docker"
		install_nextcloud_docker
        exit
        fi

if [ "$answer" = "https" ]
then
	echo "Change the HTTPs redirection to http"
		change_http_redirction_to_https
	exit
	fi
if [ "$answer" = "http" ]
then
	echo "Change the HTTPs redirection to http"
		change_https_redirction_to_http
	exit
	fi

if [ "$answer" = "certbotstg" ]
then
	echo "Disable the certbotstg to prod"
		disable_the_certbotstg_to_prod
	exit
	fi


if [ "$answer" = "certbotprod" ]
then
	echo "Enable the certbotprod to stg"
		disable_the_certbotprod_to_stg
	exit
	fi
