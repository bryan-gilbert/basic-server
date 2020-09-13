#!/usr/bin/env bash

: "${new_user:=$1}"
: "${new_password:=$2}"

if [[ -z "$new_user" || -z "$new_password" ]]; then
    echo "Usage requires new user id, password"
    exit
fi

echo ''
echo ''
echo '************* Create a sudo user ${new_user} *******************'

new_user_homedir=/home/"${new_user}"

addgroup ssh-access

echo Create docker group to allow this user to run docker commands without needing sudo
addgroup docker

# Create the user; add to group; create home directory (-m); set password hashed
useradd -G users,sudo,ssh-access,docker -m -s /bin/bash -p $(echo "${new_password}" | openssl passwd -1 -stdin) "${new_user}"

echo Show information about the user:
getent passwd "${new_user}"
id -Gn "${new_user}"

echo Copy public SSH keys installed by Digital Ocean in root into new users home directory
cp -R /root/.ssh/ "${new_user_homedir}"

chmod 700 "${new_user_homedir}"/.ssh
chmod 600 "${new_user_homedir}"/.ssh/*
chown -R "${new_user}":"${new_user}" "${new_user_homedir}"/.ssh

exit


