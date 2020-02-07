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
echo '   #   ACME_CA_URI: https://acme-staging.api.letsencrypt.org/directory' >> docker-compose.yml
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


}

start_docker_network_8
