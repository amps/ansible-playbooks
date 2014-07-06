#!/usr/bin/env bash

# Script setup
## Exit when command fails
set -e
## Exit on undeclared variables
set -u


# Utilities

###### Arguments: ($1=prompt, $2=suggestion, $3=variable, ${*:4}=extra)
ask() {
    read ${*:4} -p "$1: ($2) " temp 
    declare -g $3=${temp:-$2}
}

genpasswd() {
    declare -g passwd=$(openssl rand -base64 15)
}



vault_file=".vault"

if [ -f "$vault_file" ]; then
    echo "Nothing to do for ${vault_file}"
else
    echo "Generating vault password"
    genpasswd
    echo "$passwd" > $vault_file
    echo "Wrote vault password to ${vault_file}"
fi

# user.yml
user_yml_file="./roles/common/vars/user.yml"
if [ -f "$user_yml_file" ]; then
    echo "Nothing to do for ${user_yml_file}"
else
ask "User name" "ansible" user_name
genpasswd
ask "User pass" "$passwd" user_pass -s
touch $user_yml_file
template=$(cat<<EOF
---
user: '$user_name'
password: '$user_pass'
EOF
)

echo "Creating ${user_yml_file}"
echo "$template" > $user_yml_file
echo "Encrypting ${user_yml_file}"
ansible-vault encrypt  --vault-password-file=${vault_file} $user_yml_file
fi
