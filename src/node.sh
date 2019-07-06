#!/usr/bin/env bash

echo '************* Installing Nodejs v12.x and NPM *******************'

curl -sL https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs npm

echo '************* Installed Nodejs and NPM *******************'


exit
