#!/bin/bash


start_docker_network_8 ()
{
su - docker <<EOF
docker network create nginx-proxy
mkdir ~/nginx-proxy && cd ~/nginx-proxy
touch docker-compose.yml
echo "version: '3'" >> docker-compose.yml
echo '' >> docker-compose.yml
echo 'services:' >> docker-compose.yml
echo '  nginx:' >> docker-compose.yml
echo '    image: nginx:1.13.1' >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    container_name: nginx-proxy' >> docker-compose.yml
echo '    ports:' >> docker-compose.yml
echo '      - "80:80"' >> docker-compose.yml
echo '      - "443:443"' >> docker-compose.yml
echo '    volumes:' >> docker-compose.yml
echo '      - conf:/etc/nginx/conf.d' >> docker-compose.yml
echo '      - vhost:/etc/nginx/vhost.d' >> docker-compose.yml
echo '      - html:/usr/share/nginx/html' >> docker-compose.yml
echo '      - certs:/etc/nginx/certs' >> docker-compose.yml
echo '    labels:' >> docker-compose.yml
echo '      - "com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true"' >> docker-compose.yml
echo '' >> docker-compose.yml
echo '  dockergen:' >> docker-compose.yml
echo '    image: jwilder/docker-gen:0.7.3' >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    container_name: nginx-proxy-gen' >> docker-compose.yml
echo '    depends_on:' >> docker-compose.yml
echo '      - nginx' >> docker-compose.yml
echo '    command: -notify-sighup nginx-proxy -watch -wait 5s:30s /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf' >> docker-compose.yml
echo '    volumes:' >> docker-compose.yml
echo '      - conf:/etc/nginx/conf.d' >> docker-compose.yml
echo '      - vhost:/etc/nginx/vhost.d' >> docker-compose.yml
echo '      - html:/usr/share/nginx/html' >> docker-compose.yml
echo '      - certs:/etc/nginx/certs' >> docker-compose.yml
echo '      - /var/run/docker.sock:/tmp/docker.sock:ro' >> docker-compose.yml
echo '      - ./nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl:ro' >> docker-compose.yml
echo '' >> docker-compose.yml
echo '  letsencrypt:' >> docker-compose.yml
echo '    image: jrcs/letsencrypt-nginx-proxy-companion' >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    container_name: nginx-proxy-le' >> docker-compose.yml
echo '    depends_on:' >> docker-compose.yml
echo '      - nginx' >> docker-compose.yml
echo '      - dockergen' >> docker-compose.yml
echo '    environment:' >> docker-compose.yml
echo '      NGINX_PROXY_CONTAINER: nginx-proxy' >> docker-compose.yml
echo '      NGINX_DOCKER_GEN_CONTAINER: nginx-proxy-gen' >> docker-compose.yml
echo '      ACME_CA_URI: https://acme-staging.api.letsencrypt.org/directory' >> docker-compose.yml
echo '    volumes:' >> docker-compose.yml
echo '      - conf:/etc/nginx/conf.d' >> docker-compose.yml
echo '      - vhost:/etc/nginx/vhost.d' >> docker-compose.yml
echo '      - html:/usr/share/nginx/html' >> docker-compose.yml
echo '      - certs:/etc/nginx/certs' >> docker-compose.yml
echo '      - /var/run/docker.sock:/var/run/docker.sock:ro' >> docker-compose.yml
echo '' >> docker-compose.yml
echo 'volumes:' >> docker-compose.yml
echo '  conf:' >> docker-compose.yml
echo '  vhost:' >> docker-compose.yml
echo '  html:' >> docker-compose.yml
echo '  certs:' >> docker-compose.yml
echo '' >> docker-compose.yml
echo '# Do not forget to 'docker network create nginx-proxy' before launch, and to add '--network nginx-proxy' to proxied containers. ' >> docker-compose.yml
echo '' >> docker-compose.yml
echo 'networks:' >> docker-compose.yml
echo '  default:' >> docker-compose.yml
echo '    external:' >> docker-compose.yml
echo '      name: nginx-proxy' >> docker-compose.yml
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > nginx.tmpl
docker-compose up -d
id
EOF

echo '############# Action is requierd ############'
echo 'To finish the setup pls:'
echo 'Press CTRL+D to finish'


}


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
