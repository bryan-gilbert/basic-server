#!/usr/bin/env bash

echo "Set up git configuration"
echo "Configure git?"
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

read -p "git user name " name
read -p "git user email " email

git config --global user.email "${email}"
git config --global user.name "${name}"

git config --global user.name
git config --global user.email
