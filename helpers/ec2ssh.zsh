#!/bin/sh

function _load_aws_profile() {
    local aws_profile=$1
    if [ -z "${aws_profile}" ]; then
        aws_profile=${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}
    fi
    echo $aws_profile
    return
}

function _load_aws_region() {
    local aws_region=$1
    if [ -z "${aws_region}" ]; then
        aws_region=${AWS_REGION:-$AWS_DEFAULT_REGION}
    fi
    echo $aws_region
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

function ec2ssh() {
    local aws_profile_name=$1
    local aws_region=$2
    local target_user=$3
    local target_private_key_path=$4
    local target_port=${5:-22}
    local proxy_host=$6
    local proxy_user=$7
    local proxy_key_path=$8
    local proxy_port=$9

    aws_profile_name=`_load_aws_profile $aws_profile_name`
    aws_region=`_load_aws_region $aws_region`
    target_user=`_load_user $target_user`
    target_private_key_path=`_load_ssh_private_key_path $target_private_key_path`
    target_port=`_load_port $target_port`
    proxy_user=`_load_user $proxy_user`
    proxy_key_path=`_load_ssh_private_key_path $proxy_key_path`
    proxy_port=`_load_port $proxy_port`

    if [ -z "${aws_profile_name}" ]; then
        echo "AWS profile name is required. Please call this function with aws profile name or set AWS_DEFAULT_REGION in evironment variables."
        return
    fi

    if [ -z "${aws_region}" ]; then
        echo "AWS region is required. Please call this function with aws region or set AWS_DEFAULT_REGION in environment variables."
        return
    fi

    if [ -z "${target_user}" ]; then
        echo "User is required. Please call this function with user or set USER in environment variables."
        return
    fi

    echo "Fetching ec2 host..."
    local selected_host=$(myaws ec2 ls --profile=${aws_profile_name} --region=${aws_region} --fields='InstanceId PublicIpAddress PrivateIpAddress LaunchTime Tag:Name Tag:attached_asg' | sort -k4 | fzf | cut -f2)
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
zle -N ec2ssh
