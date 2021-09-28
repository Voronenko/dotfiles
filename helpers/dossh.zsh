#!/bin/sh

function _load_do_profile() {
    local do_profile=$1
    if [ -z "${do_profile}" ]; then
        do_profile=${DO_PROFILE:-$DO_DEFAULT_PROFILE}
    fi
    echo $do_profile
    return
}

function _load_user() {
    local user=$1
    if [ -z "${user}" ]; then
        user=ubuntu
    fi
    echo $user
    return
}

function _load_ssh_private_key_path() {
    local private_key_path=$1
    if [ -z "${private_key_path}" ]; then
        private_key_path="$HOME/.ssh/id_rsa"
    fi
    echo $private_key_path
    return
}

function _load_port() {
    local port=$1
    if [ -z "${port}" ]; then
        port=22
    fi
    echo $port
    return
}

function dossh() {
    local do_profile_name=$1
    local target_user=$2
    local target_private_key_path=$3
    local target_port=${4:-22}
    local proxy_host=$5
    local proxy_user=$6
    local proxy_key_path=$7
    local proxy_port=$8

    do_profile_name=`_load_do_profile $aws_profile_name`
    target_user=`_load_user $target_user`
    target_private_key_path=`_load_ssh_private_key_path $target_private_key_path`
    target_port=`_load_port $target_port`
    proxy_user=`_load_user $proxy_user`
    proxy_key_path=`_load_ssh_private_key_path $proxy_key_path`
    proxy_port=`_load_port $proxy_port`

    if [ -z "${do_profile_name}" ]; then
        echo "DIGITAL OCEAN context name is required. Please call this function with do context name or set DO_DEFAULT_PROFILE in evironment variables."
        return
    fi

    if [ -z "${target_user}" ]; then
        echo "User is required. Please call this function with user or set USER in environment variables."
        return
    fi

    echo "Fetching digitalocean host..."
    local selected_host=$(doctl compute droplet list --context $do_profile_name --format ID,PublicIPv4,PrivateIPv4,Name,Image,Status --no-header | sort -k4 | fzf | awk '{print $2}')
    if [ -n "${selected_host}" ]; then
        if [ -z "${proxy_host}" ]; then
            BUFFER="ssh -i ${target_private_key_path} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${target_port} ${target_user}@${selected_host}"
        else
            BUFFER="ssh -i ${proxy_key_path} -p ${proxy_port} -t ${proxy_user}@${proxy_host} ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${target_private_key_path} ${target_user}@${selected_host}"
        fi
        if zle; then
            zle accept-line
        else
            print -z "$BUFFER"
        fi
    fi
    if zle; then
        zle clear-screen
    fi
}
zle -N dossh
