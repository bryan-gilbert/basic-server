#!/bin/bash

# ######################
# Run this script on your development machine to configure a fresh remote server.


function usage() {
    echo "Usage $0 server_ip_address new_user_name (all)"
    cat <<-____HERE
    This script will configure a newly created Debian server accessible via an IP address (e.g. on Digital Ocean)
    This script also creates a new user on the server.
    You must provide the IP address and the name of a new user.

    Before invoking this script:
       - login to DigitalOcean
       - create a droplet; (e.g. Debian, 1GB ($5/mth) Toronto or San Fran)
       - make sure droplet includes your ssh key
____HERE
    exit 1
}

server_ip=$1
new_user=$2
all_scripts=$3


if [[ -z "$server_ip" ]]; then
    usage
    exit
fi

if [[ -z "$new_user" ]]; then
    usage
    exit
fi

if [[ -z "$all_scripts" ]]; then
    all_scripts=false
fi

echo Create remote sudo user: "${new_user}" on "${server_ip}"
echo ''
echo What will be the password for "${new_user}" on "${server_ip}"
read -s -p "password " new_password

echo Enter the password again
read -s -p "password " new_password2

if [[ $new_password != $new_password2 ]]; then
    echo Passwords do not match
    exit
fi

echo ''

# Can check port usage here: https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
read -p "SSH Port? [22] " ssh_port
ssh_port=${ssh_port:-22}

echo ''

echo 'What shell do you want to install? Enter the number that corresponds to your choice below'
options=("bash" "zsh")
select remote_shell in "${options[@]}"
do
    case "${remote_shell}" in
        "bash")
            break
            ;;
        "zsh")
            break
            ;;
    esac
done

echo "Ready! .... User: ${new_user} on ${server_ip} port: ${ssh_port} shell: ${remote_shell} "
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
echo ''

echo '***************** Delete Known Host Key - if one exists ********************'
ssh-keygen -f $HOME/.ssh/known_hosts -R "${server_ip}"

echo ''
echo ''

function runOne (  ) {
    script=$1
    if [[ $all_scripts ]]
    then 
        ssh root@"${server_ip}" "bash -s" -- < ./src/$script "${new_user}" "${new_password}" "${remote_shell}" "${ssh_port}"
    else
        read -p "Run [y] or skip[n] ${script}? (Y/N): " confirm
        if [[ $confirm == [yY] ]]
        then
            ssh root@"${server_ip}" "bash -s" -- < ./src/$script "${new_user}" "${new_password}" "${remote_shell}" "${ssh_port}"
            echo ''
            echo ''
        else
            echo 'Skipped ${script}'
        fi
    fi
}

echo Install basic components on "${server_ip}"
runOne basic_setup.sh

echo Create "${new_user}" on "${server_ip}" using
runOne create_new_user.sh

echo Install Docker and Docker Compose
runOne docker20.sh

echo Install Node and NPM
runOne node.sh

echo Install Certbot
runOne certbot.sh

if [[ "${remote_shell}" == 'zsh' ]]; then
    runOne oh-my-zsh-install.sh
fi

echo "Set up user while we still use port 22"
./configure_user.sh ${server_ip} ${new_user}

echo ""
echo "You can now log on with the following"
echo "ssh ${new_user}@${server_ip} -p ${ssh_port}"

echo Configure the Uncomplicated Firewall
# Modify the firewall configuration but don't enable yet as we'll be locked out if the SSH port has changed
runOne firewall.sh

echo Make the SSH Daemon more secure
# Modify the SSH Daemon configuration but don't enable it yet as we'll be locked out if the SSH port has changed
runOne ssh_daemon.sh

echo Enable changes to the firewall and SSH Daemon
echo After this command is executed, root can no longer ssh and the new ssh_port ${ssh_port} will be active
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
ssh root@"${server_ip}" 'service ssh restart; ufw --force enable; ufw status'

