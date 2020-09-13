#!/usr/bin/env bash

. .env

if [[ -z "${new_user}" ]] || [[ -z "${server_ip}" ]]; then
    echo "Must set up the .env file with user id and server ip"
    exit
fi
echo User: "${new_user}" IP: "${server_ip}"
echo ''
ls -al ~/.ssh/
echo "Enter the ssh key you want to copy, the private file, the one without the .pub extension."
echo "Or press nothing to skip"
read yourkey

if [ -f ~/.ssh/"${yourkey}" ]; then
  scp ~/.ssh/"${yourkey}" "${new_user}@${server_ip}:/home/${new_user}"/.ssh
  scp ~/.ssh/"${yourkey}.pub" "${new_user}@${server_ip}:/home/${new_user}"/.ssh
fi
