#!/bin/zsh

function _load_user() {
    local user=$1
    if [ -z "${user}" ]; then
        user=root
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

function hcloudssh() {
    local target_user=$1
    local target_private_key_path=$2
    local target_port=${3:-22}

    target_user=`_load_user $target_user`
    target_private_key_path=`_load_ssh_private_key_path $target_private_key_path`
    target_port=`_load_port $target_port`

    echo "Fetching Hetzner Cloud server host..."
    local selected_host=$(hcloud server list | awk 'NR>1 {OFS=" "; printf "%-10s \033[36m%-50s\033[0m %-20s \033[32m%-20s \033[33m%-20s\033[0m %-20s\n", $1, $2, $3, $4, $5, $8}' | fzf --ansi | awk '{print $4}')
    if [ -n "${selected_host}" ]; then
        # -i ${target_private_key_path}
        BUFFER="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p ${target_port} ${target_user}@${selected_host}"
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

zle -N hcloudssh
