#!/bin/bash

add_autoupdate_1_action () {
apt-get update && apt-get upgrade -y
}

install_needed_application_2_action () {
apt install sudo curl vim fail2ban pwgen -y
}

modify_application_3_action ()
{
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)

fail2ban-client set sshd addignoreip $IP


A="maxretry = 5"
N="maxretry = 3"
sed -i "s/$A/$N/g" /etc/fail2ban/jail.local

Ab="bantime  = 10m"
Nb="bantime  = 3600"
sed -i "s/$Ab/$Nb/g" /etc/fail2ban/jail.local

fail2ban-client reload sshd

fail2ban-client set sshd addignoreip $IP
fail2ban-client get sshd ignoreip
}

add_user_4_action ()
{

adduser docker --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
adduser docker sudo

}


install_docker_5_action ()
{
curl -sS https://get.docker.com/ | sh
}

modify_docker_6_action ()
{
usermod -aG $docker_user docker

systemctl enable docker
}

install_docker_composer_7_action ()
{
curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose | sudo -E bash
}


start_next_script ()
{
curl -sL  https://raw.githubusercontent.com/stefanG41/vps_setup/master/install.sh | sudo -E bash
}


echo_user_account_info ()

{
echo 'In the script was created a user account like docker, pls chankge the password for the user to use sudo if is needed.'
echo 'passwd docker    to set a new password!'
}


add_autoupdate_1_action
install_needed_application_2_action
modify_application_3_action
add_user_4_action
install_docker_5_action
modify_docker_6_action
install_docker_composer_7_action
start_next_script
echo_user_account_info
