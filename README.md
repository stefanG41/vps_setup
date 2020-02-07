# vps_setup


Start the setup with:


curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/vps_setup.sh | sudo -E bash

switch to the new docker user and run followong command:
A part what need to be done too is install the nginx-proxy

su - docker 


curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/nginx-proxy_setup.sh | bash



wget https://raw.githubusercontent.com/stefanG41/vps_setup/master/wp_install.sh

bash wp_install.sh
