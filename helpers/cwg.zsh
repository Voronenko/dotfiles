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
    local aws_profile_name=""
    local aws_region=""
    local extra_args=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --profile=*)
                aws_profile_name="${1#*=}"
                shift
                ;;
            --region=*)
                aws_region="${1#*=}"
                shift
                ;;
            -b1h|-b3h|-b12h|-b1d|-f|-t|-i|-s|-n|-r|-l|-g|-v|-q|--*)
                extra_args="$extra_args $1"
                shift
                ;;
            *)
                if [[ $1 == -* ]] && [[ $# -gt 1 ]]; then
                    extra_args="$extra_args $1 $2"
                    shift 2
                else
                    shift
                fi
                ;;
        esac
    done

    aws_profile_name=`_load_aws_profile $aws_profile_name`
    aws_region=`_load_aws_region $aws_region`

    if [ -z "${aws_profile_name}" ]; then
        echo "AWS profile name is required. Please call this function with aws profile name or set AWS_DEFAULT_PROFILE in environment variables."
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

        # Ask for starting time
        echo "Starting time options:"
        local start_time=$(echo -e "0m\n5m\n10m\n15m\n30m\n60m\n2h\n4h\n8h\n1d" | fzf --prompt="Starting time: ")

        # Build the command with start time if selected (not 0m)
        local start_option=""
        if [ -n "${start_time}" ] && [ "${start_time}" != "0m" ]; then
            start_option="--start=${start_time}"
        fi

        BUFFER="cw tail -f ${trimmed_group} --no-color ${extra_args} ${start_option} | lnav"
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
