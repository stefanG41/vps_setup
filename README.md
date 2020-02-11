# vps_setup

Start the setup with:

apt-get install sudo curl -y && curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/vps_setup.sh | sudo -E bash


A part what need to be done too is install the nginx-proxy, the script is install the docker container under the user 'docker' what was created on the setup script.

curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/nginx-proxy_setup.sh | sudo -E bash


switch to the new docker user and run followong command, in my case I created a user called "docker":


su - docker 

wget https://raw.githubusercontent.com/stefanG41/vps_setup/master/wp_install.sh | bash

bash wp_install.sh
