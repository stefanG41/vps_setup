#!/bin/bash

add_user_4_action ()
{
echo 'Plaese add user account for Docker, the new account will be added to sudo group. You need to provide three times the new password.'
read -e docker_user
echo 'Plaese add password for the new docker user'
read -e -s docker_password

adduser $docker_user --gecos "First Last,RoomNumber,WorkPhone,HomePhone"
adduser $docker_user sudo
}
