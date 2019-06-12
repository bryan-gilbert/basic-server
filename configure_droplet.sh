#!/bin/bash

# This script configures a remote DigitalOcean server called a 'droplet'

# Before invoking this script:
#   - login to DigitalOcean
#   - create a droplet; (e.g. Debian, 1GB ($5/mth) Toronto or San Fran)
#   - make sure droplet includes your ssh key


# Then, from your desktop / laptop run:  ./configure_droplet.sh "server_ip"
#   - where "server_ip" is the ip address of the newly instantiated DigitalOcean server

if [ -z "$1" ]
then
    echo 'Error:  you must provide the IP address of the remote server'
    exit
fi


echo Create remote sudo user: $USER

echo What should be the password for $USER on $1
read NEW_PASSWORD

echo '***************** Delete Known Host Key - if one exists ********************'
ssh-keygen -f $HOME/.ssh/known_hosts -R "$1"

echo Copy hardened sshd_config from local to remote
scp ./sshd_config root@$1:/etc/ssh/sshd_config.secure

echo Creating $USER on $1 using this password: $NEW_PASSWORD
ssh root@$1 "bash -s" -- < ./initial_remote_setup.sh "$USER" "$NEW_PASSWORD"
