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

function _load_port() {
    local port=$1
    if [ -z "${port}" ]; then
        port=22
    fi
    echo $port
    return
}

function _load_local_port() {
    local port=$1
    if [ -z "${port}" ]; then
        port=8080
    fi
    echo $port
    return
}


function ec2forward() {
    local aws_remote_port=${1:-80}
    local aws_local_port=${2:-8080}
    local aws_profile_name=$3
    local aws_region=$4

    aws_profile_name=`_load_aws_profile $aws_profile_name`
    aws_region=`_load_aws_region $aws_region`
    aws_port=`_load_port $aws_remote_port`
    aws_local_port=`_load_port $aws_local_port`

    if [ -z "${aws_profile_name}" ]; then
        echo "AWS profile name is required. Please call this function with aws profile name or set AWS_DEFAULT_REGION in evironment variables."
        return
    fi

    if [ -z "${aws_region}" ]; then
        echo "AWS region is required. Please call this function with aws region or set AWS_DEFAULT_REGION in environment variables."
        return
    fi

    echo "Fetching ec2 host..."
    local selected_host=$(myaws ec2 ls --profile=${aws_profile_name} --region=${aws_region} --fields='InstanceId PublicIpAddress PrivateIpAddress LaunchTime Tag:Name Tag:attached_asg' | sort -k4 | fzf | cut -f1)
    if [ -n "${selected_host}" ]; then
        BUFFER="aws --region=${aws_region} --profile=${aws_profile_name} ssm start-session --target ${selected_host} --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"${aws_port}\"],\"localPortNumber\":[\"${aws_local_port}\"]}'"
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
zle -N ec2forward
