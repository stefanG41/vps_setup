# vps_setup


Start the setup with:


curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/vps_setup.sh | sudo -E bash


A part what need to be done too is install the nginx-proxy

curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/nginx-proxy_setup.sh | sudo -E bash


switch to the new docker user and run followong command:


su - docker 






wget https://raw.githubusercontent.com/stefanG41/vps_setup/master/wp_install.sh

bash wp_install.sh
