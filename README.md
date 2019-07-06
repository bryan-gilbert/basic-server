# Basic Secure Server

A command-line script for building a basic secure server on Digital Ocean

## Features

The script configures / installs the following on the remote server:

  * sets the timezone to Vancouver, Canada
  * creates a new user using the currently logged in user
  * sets a password for the new user with a password provided
  * gives new newly created user sudo privilages
  * updates and upgrades all packages
  * installs: ufw, docker, docker-compose, git, curl, zsh, wget, nodejs, npm
  * if zsh is selected as the shell, installs oh-my-zsh and the bullet-train-theme
  * replaces sshd_config with version that:
    * prohibits root logins
    * allows only you access with your public key
    * configures the ssh port selected
  * configures ufw (uncomplicated firewall) to expose only the following ports:
    * 80, 443, 123 and the port used by the ssh daemon


## Usage

1) Clone this repository:

 ```bash
 git clone https://github.com/jonathan-longe/basic-server.git
 ```

2) Login to your Digital Ocean account and create a new virtual server ("droplet").  The remote server must have your public ssh key installed -- for example `~/.ssh/id_rsa.pub

3) Then on a local machine:

```bash
./configure_droplet.sh <IP_ADDRESS_OF_REMOTE_SERVER> <NEW_USER_NAME>
```

where ```<IP_ADDRESS_OF_REMOTE_SERVER>``` is the IP address of your droplet and 
```<NEW_USER_NAME>``` is the name of your first admin user.  The script will prompt you for the user's
password, ssh port and user shell.  See User, Port and Shell below. 

4) After the script has finished, ssh from your local machine:
```bash
ssh <NEW_USER_NAME>@<IP_ADDRESS_OF_REMOTE_SERVER>
```
If you've used a non-standard port for ssh, use a '-p' parameter like this:

```bash
ssh -p<SSH_PORT> <IP_ADDRESS_OF_REMOTE_SERVER>
```

## User
After configuring the droplet you may wish to set up the user further.

### First time user setup
```
./configure_user.sh <IP_ADDRESS> <USER_NAME>
```
This script will copy configuration files and scripts from this repo to the remote server placing the files into the given user's home directory.
You must provide the IP address and the name of user.  This script also prompts you with instructions to copy
ssh keys from your machine to the remote user's .ssh directory.  This is useful if you are using github or gitlab via ssh and want to
use the same keys.  You'd only do this if (a) you need to do some development on the droplet and (b) you
don't mind having a copy of your private ssh key on that droplet. (An alternative to this is to create a new public/private key pair
on the droplet for gitlab/github and register the public key with the git service.)

### On droplet user configuration
The next step is for the user to log onto that server and run the script 'user_setup.sh' that was copied over above.
That script will set up the user's bash profile with aliases, ssh-agent for registering ssh keys, and configure git for
your user.


## SSH Port
The droplet configure script allows you to change the default SSH port (22) to whatever else you may wish.
This is enhances security through obscurity. It does dramatically reduce the number of log entries in the system
files that track access requests because it eliminates all but the most tenacious malicious bots.
 

## Shell
The droplet configure script allows for the admin user to have bash or zsh shell.


## Credits

This script borrows heavily from [Bryan Gilbert's excellent instructions](https://github.com/bryan-gilbert/may14/)
