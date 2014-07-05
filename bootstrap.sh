#!/usr/bin/env bash

# Script setup
## Exit when command fails
set -e
## Exit on undeclared variables
set -u


# Utilities

###### Arguments: ($1=prompt, $2=suggestion, $3=variable)
ask() {
    read -p "$1: ($2) " temp
    declare -g $3=${temp:-$2}
}

# user.yml
user_yml_file="user.yml"
if [ ! -f $user_yml_file ]; then
ask "User name" "ansible" user_name
read -sp "User pass: " user_pass
touch $user_yml_file
template=$(cat<<EOF
---
user: '$user_name'
password: '$user_pass'
EOF
)

echo "$template" > $user_yml_file
ansible-vault encrypt $user_yml_file

fi