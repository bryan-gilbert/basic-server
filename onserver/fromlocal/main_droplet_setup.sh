#!/bin/bash

set -e

# ######################
cat <<-____HERE
    This script will configure a newly created Debian server accessible via an IP address (e.g. on Digital Ocean)
    You must provide the IP address and ssh port via an .env file. See sample.env.
    Before invoking this script:
       - login to DigitalOcean
       - create a droplet; (e.g. Debian, 1GB ($5/mth) Toronto or San Fran)
       - make sure droplet includes your ssh key
     Run this script on your development machine to configure a fresh remote server.

    This script prepares the server with a new sudo user and locks down root access.
    The second step is to ssh onto the server with the new user account and run the desired scripts that were copied over.
____HERE

. .env

if [[ -z "$server_ip" || -z "$ssh_port" || -z "$new_user" || -z "$password" ]]; then
    echo "Usage depends on configuration in a .env file"
    exit
fi

echo '***************** Delete Known Host Key - if one exists ********************'
ssh-keygen -f $HOME/.ssh/known_hosts -R "${server_ip}"

# '************* Secure SSH *******************'
ssh root@"${server_ip}" "bash -s" -- < ./remote/ssh_daemon.sh "${ssh_port}"

# '************* Firewall *******************'
ssh root@"${server_ip}" "bash -s" -- < ./remote/firewall.sh "${ssh_port}"

# '************* Create a sudo user *******************'
ssh root@"${server_ip}" "bash -s" -- < ./remote/create_new_user.sh ${new_user} ${password}

./user_setup.sh

./user_ssh_key_cp.sh

echo "Final step -- turn off root access"
./enable_firewall.sh

echo "************* DONE remote server" "${server_ip}" "*******************"
echo ""
echo "You can now log on with the following"
echo "ssh ${new_user}@${server_ip} -p ${ssh_port}"
echo ""
echo "run scripts on server as sudo user to complete the setup"
