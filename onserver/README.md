# Build a server

This folder contains yet another attempt of a comprehensive and flexible set of scripts that can be used to set up a DO server.  This time the focus will be to do the minimum on the local development machine (your working computer) and to shift more to be done on the server. The goal is to create a series of setup scripts that can be run, on the server, over and over to install and update.

One reason for this new approach is to allow the user to pick what components they need.  For example, when this project started all servers would have nginx installed. That meant we needed certbot to set up certificates.  But now some servers can use Caddy which has ssl built in.  Also, we may want to have ubuntu or debian versions and we may want to set up different user accounts. Some with sudo and others without.



https://docs.github.com/en/github/using-git/changing-a-remotes-url#switching-remote-urls-from-https-to-ssh

git remote set-url origin git@github.com:USERNAME/REPOSITORY.git
