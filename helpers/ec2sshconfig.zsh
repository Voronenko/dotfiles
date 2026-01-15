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

function ec2sshconfig() {
    local aws_profile_name=$1
    local aws_region=$2

    aws_profile_name=`_load_aws_profile $aws_profile_name`
    aws_region=`_load_aws_region $aws_region`

    # If we are in assume role environment, make sure to get temporary keys into env
    if [ ! -z "${AWS_ASSUME_ROLE_NAME}" ]; then
      source $HOME/dotfiles/bin/source-aws-sts-role-keys.sh
    fi

    if [ -z "${aws_profile_name}" ]; then
        echo "AWS profile name is required. Please call this function with aws profile name or set AWS_DEFAULT_REGION in evironment variables."
        return
    fi

    if [ -z "${aws_region}" ]; then
        echo "AWS region is required. Please call this function with aws region or set AWS_DEFAULT_REGION in environment variables."
        return
    fi

    echo "Fetching ec2 instances..."
    local selected_instance=$(aws --profile=${aws_profile_name} --region=${aws_region} ec2 describe-instances \
        --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,PrivateIpAddress,Tags[?Key==`Name`].Value|[0],LaunchTime,Tags[?Key==`aws:autoscaling:groupName`].Value|[0]]' \
        --output text | sort -k5 | fzf)

    if [ -n "${selected_instance}" ]; then
        local instance_id=$(echo "${selected_instance}" | cut -f1)
        local public_ip=$(echo "${selected_instance}" | cut -f2)
        local private_ip=$(echo "${selected_instance}" | cut -f3)
        local name_tag=$(echo "${selected_instance}" | cut -f4)
        local launch_time=$(echo "${selected_instance}" | cut -f5)

        # Use name tag if available, otherwise use instance ID
        local host_name="${name_tag}"
        if [ -z "${host_name}" ]; then
            host_name="${instance_id}"
        fi

        echo ""
        echo "Selected instance: ${host_name} (${instance_id})"
        echo ""

        # Query security groups for the selected instance
        echo "Fetching security groups for instance..."
        local security_groups=$(aws --profile=${aws_profile_name} --region=${aws_region} ec2 describe-instances \
            --instance-ids ${instance_id} \
            --query 'Reservations[*].Instances[*].SecurityGroups[*].[GroupId,GroupName]' \
            --output text)

        # Parse security groups and let user select one
        echo "Select security group for whitelisting..."
        local selected_sg=$(echo "${security_groups}" | fzf)

        if [ -n "${selected_sg}" ]; then
            local sg_id=$(echo "${selected_sg}" | cut -f1)
            local sg_name=$(echo "${selected_sg}" | cut -f2)

            # Set environment variable for security group ID
            export AWS_INSTANCE_SG_ID="${sg_id}"

            echo ""
            echo "========================================="
            echo "SSH Config Block:"
            echo "========================================="
            cat <<EOF
Host ${host_name}
    SetEnv TERM=xterm
    User ubuntu
    Hostname ${instance_id}
    ProxyCommand sh -c "aws ssm start-session --profile ${aws_profile_name} --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
#    LocalForward 5432 127.0.0.1:5432
    ForwardAgent yes
EOF

            echo ""
            echo "========================================="
            echo "Whitelist Command:"
            echo "========================================="
            echo "export AWS_INSTANCE_SG_ID=\"${sg_id}\""
            echo ""
            cat <<'EOF'
MY_IP=$(curl -s https://checkip.amazonaws.com/)
echo "Your IP is: $MY_IP"
aws ec2 authorize-security-group-ingress \
  --group-id "$AWS_INSTANCE_SG_ID" \
  --protocol tcp \
  --port 22 \
  --cidr $MY_IP/32 || true
EOF
            echo ""
            echo "========================================="
            echo "Security Group ID: ${sg_id} (${sg_name})"
            echo "========================================="
        fi
    fi
    if zle; then
        zle clear-screen
    fi
}
zle -N ec2sshconfig
