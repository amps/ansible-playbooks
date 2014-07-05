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

# Ansible

## Check if ansible is installed
if ! [ hash ansible 2>/dev/null ]; then
    ## Install ansible

    
    ansible_stdlib_dir="$(pwd)/ansible-std-lib"
    if [ -d "$ansible_stdlib_dir" ]; then

    else

    ### Create standard library folder
    mkdir -p $ansible_stdlib_dir

    ### Do all work in a new directory
    mkdir -p .ansible-tmp
    cd .ansible-tmp
    ### Download the latest release
    curl -o ansible.tar.gz http://releases.ansible.com/ansible/ansible-latest.tar.gz
    mkdir -p ansible-src
    tar xvfz ansible.tar.gz --directory ansible-src --strip-components=1
    cd ansible-src
    echo "its ${ansible_stdlib_dir}"
    ### Install
    ANSIBLE_LIBRARY=${ansible_stdlib_dir} python setup.py install --force --user
    
    ### Go back to the base directory
    cd -
    cd ..

    ### Delete the installation directory
    rm -rf .ansible-tmp
fi

fi

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