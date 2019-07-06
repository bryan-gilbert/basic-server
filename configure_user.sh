#!/usr/bin/env bash

# ######################
# Run this script on your development machine to setup a user on a remote server.

function usage() {
    echo "Usage $0 server_ip_address user_name"
    cat <<-____HERE
    This script will copy configuration files and scripts from this machine to the remote server placing the files into the given user's home directory.
    The next step is for the user to log onto that server and run 'user_setup.sh'
    You must provide the IP address and the name of user.
____HERE
    exit 1
}

: "${server_ip:=$1}"
: "${user_id:=$2}"

if [[ -z "${user_id}" ]]; then
    usage
    exit
fi
if [[ -z "${server_ip}" ]]; then
    usage
    exit
fi

echo User: "${user_id}" IP: "${server_ip}"

rhome=/home/${user_id}
address=${user_id}"@"${server_ip}
source=remote_setup_scripts

echo "Make the setup scripts directory in the remote user's home"
ssh "${address}" "mkdir -p "${rhome}"/setup_scripts"

echo "Copy files from here to there"
scp -r "${source}"/* "${address}":"${rhome}"/setup_scripts

echo "Listing the remote files to verify they arrived"
ssh "${address}" "ls -al "${rhome}"/setup_scripts"


echo ''
ls -al ~/.ssh/
echo "Pick which key(s) you want on your server and run a scp command like this"

echo "scp ~/.ssh/yourkey "${address}":"${rhome}"/.ssh
