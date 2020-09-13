#!/bin/bash
set -e

. .env

if [[ -z "$server_ip" || -z "$ssh_port" || -z "$new_user" ]]; then
    echo "Usage depends on configuration in a .env file"
    exit
fi

echo "Copy server setup scripts to /home/${new_user}/server_setup"
ssh "${new_user}@${server_ip}" "mkdir -p /home/"${new_user}"/server_setup"
scp -r ../server_setup/* "${new_user}@${server_ip}:/home/${new_user}/server_setup"

echo "Copy user setup scripts to /home/${new_user}/user_setup"
ssh "${new_user}@${server_ip}" "mkdir -p /home/"${new_user}"/user_setup"
scp -r ../user_setup/* "${new_user}@${server_ip}:/home/${new_user}/user_setup"

scp -r ../user_setup/bashrc/.bash_aliases "${new_user}@${server_ip}:/home/${new_user}/"
scp -r ../user_setup/bashrc/.bash_customize_ssh "${new_user}@${server_ip}:/home/${new_user}/"

REF="if [ -f ~/.bash_customize_ssh ]; then source ~/.bash_customize_ssh; fi"
ssh "${new_user}@${server_ip}" "echo '${REF}' >> /home/${new_user}/.bashrc"
