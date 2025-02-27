#!/bin/zsh

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

function cwg() {
    local aws_profile_name=$1
    local aws_region=$2

    aws_profile_name=`_load_aws_profile $aws_profile_name`
    aws_region=`_load_aws_region $aws_region`

    if [ -z "${aws_profile_name}" ]; then
        echo "AWS profile name is required. Please call this function with aws profile name or set AWS_DEFAULT_REGION in evironment variables."
        return
    fi

    if [ -z "${aws_region}" ]; then
        echo "AWS region is required. Please call this function with aws region or set AWS_DEFAULT_REGION in environment variables."
        return
    fi

    echo "Fetching CloudWatch groups..."
    local selected_group=$(aws --profile=${aws_profile_name} --region=${aws_region} logs describe-log-groups --output text | cut -f4 | fzf)
    if [ -n "${selected_group}" ]; then

        local trimmed_group=$(echo "${selected_group}" | sed 's/^.*:log-group://')
        BUFFER="cw tail -f ${trimmed_group} --no-color | lnav"
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
zle -N cwg
