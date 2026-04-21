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

function _extract_cluster_name() {
    local cluster_arn=$1
    # Extract cluster name from ARN: arn:aws:ecs:region:account:cluster/cluster-name
    echo $cluster_arn | awk -F'/' '{print $NF}'
}

function _extract_task_id() {
    local task_arn=$1
    # Extract task ID from ARN: arn:aws:ecs:region:account:task/task-id
    echo $task_arn | awk -F'/' '{print $NF}'
}

function _shorten_task_id() {
    local task_id=$1
    # Show first 4 chars .. last 2 chars for main list
    echo "${task_id:0:4}..${task_id: -2}"
}

function ecstask() {
    local aws_profile_name=$1
    local aws_region=$2

    aws_profile_name=`_load_aws_profile $aws_profile_name`
    aws_region=`_load_aws_region $aws_region`

    # If we are in assume role environment, make sure to get temporary keys into env
    if [ ! -z "${AWS_ASSUME_ROLE_NAME}" ]; then
      source $HOME/dotfiles/bin/source-aws-sts-role-keys.sh
    fi

    local aws_profile_arg=""
    if [ -n "${AWS_ACCESS_KEY_ID}" ]; then
        # Use existing keys in environment, ignore profile
        :
    elif [ -n "${aws_profile_name}" ]; then
        aws_profile_arg="--profile=${aws_profile_name}"
    else
        echo "AWS profile name is required. Please call this function with aws profile name or set AWS_DEFAULT_REGION in environment variables."
        return
    fi

    if [ -z "${aws_region}" ]; then
        echo "AWS region is required. Please call this function with aws region or set AWS_DEFAULT_REGION in environment variables."
        return
    fi

    # Step 1: Select cluster
    echo "Fetching ECS clusters..."
    local cluster_arns=$(aws ${aws_profile_arg} --region=${aws_region} ecs list-clusters \
        --query 'clusterArns[]' --output text | tr '\t' '\n' | grep -v '^$')

    if [ -z "${cluster_arns}" ]; then
        echo "No ECS clusters found in region ${aws_region}"
        return
    fi

    local cluster_count=$(echo "${cluster_arns}" | wc -l)
    local selected_cluster_arn=""

    if [ "${cluster_count}" -eq 1 ]; then
        # Auto-select single cluster
        selected_cluster_arn="${cluster_arns}"
        local cluster_name=$(_extract_cluster_name "${selected_cluster_arn}")
        echo "Auto-selected cluster: ${cluster_name}"
    else
        # Let user select from multiple clusters
        selected_cluster_arn=$(echo "${cluster_arns}" | \
            fzf --prompt="Select cluster> " --height=40%)

        if [ -z "${selected_cluster_arn}" ]; then
            echo "No cluster selected."
            return
        fi
        local cluster_name=$(_extract_cluster_name "${selected_cluster_arn}")
    fi

    # Step 2: Get all tasks in the cluster
    echo "Fetching tasks..."
    local task_arns=$(aws ${aws_profile_arg} --region=${aws_region} ecs list-tasks \
        --cluster "${cluster_name}" \
        --desired-status RUNNING \
        --query 'taskArns[]' --output text | tr '\t' '\n')

    if [ -z "${task_arns}" ]; then
        echo "No running tasks found in cluster ${cluster_name}"
        return
    fi

    # Step 3: Get comprehensive task details
    local task_arn_list=$(echo "${task_arns}" | jq -R -s 'split("\n") | map(select(length > 0))')

    local task_details
    task_details=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-tasks \
        --cluster "${cluster_name}" \
        --tasks "${task_arn_list}" \
        --query 'tasks[*].[taskArn,group,containerInstanceArn,enableExecuteCommand,lastStatus,desiredStatus,taskDefinitionArn,healthStatus,launchType,containers[0].name]' \
        --output text 2>&1)

    local exit_code=$?

    if [ $exit_code -ne 0 ] || [ -z "${task_details}" ]; then
        echo "Failed to fetch task details."
        return
    fi

    # Step 4: Build EC2 instance mapping
    # Store: short_container_instance_arn -> ec2_instance_id
    local container_instance_arns=$(echo "${task_details}" | awk -F'\t' '{print $3}' | sort -u | grep -v "^None$" | grep -v "^$")
    local ec2_lookup_file=$(mktemp)


    if [ -n "${container_instance_arns}" ]; then
        # Process each container instance ARN individually
        echo "${container_instance_arns}" | while read -r container_arn; do
            if [ -n "${container_arn}" ]; then
                local ec2_mapping=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-container-instances \
                    --cluster "${cluster_name}" \
                    --container-instances "${container_arn}" \
                    --query 'containerInstances[0].[containerInstanceArn,ec2InstanceId]' \
                    --output text 2>/dev/null)

                if [ -n "${ec2_mapping}" ]; then
                    local arn=$(echo "${ec2_mapping}" | awk -F'\t' '{print $1}')
                    local ec2_id=$(echo "${ec2_mapping}" | awk -F'\t' '{print $2}')
                    local short_arn=$(echo "${arn}" | awk -F'/' '{print $NF}')
                    echo "${short_arn}=${ec2_id}" >> "${ec2_lookup_file}"
                fi
            fi
        done
    fi

    # Step 5: Build preview lookup file and formatted task list
    # Create a lookup file with format: task_id|short_task_id|last_status|desired_status|task_def|health_status|group|launch_type|ec2_instance|exec_indicator|container_name
    local preview_lookup_file=$(mktemp)
    local formatted_tasks=""

    # Process task details in the same subshell that reads from ec2_lookup_file
    formatted_tasks=$(
        while IFS=$'\t' read -r task_arn group container_arn exec_status last_status desired_status task_def health_status launch_type container_name; do
            local task_id=$(_extract_task_id "${task_arn}")
            local short_task_id=$(_shorten_task_id "${task_id}")
            local ec2_instance=""
            local exec_indicator="NO"

            # Lookup EC2 instance ID from the lookup file
            if [ -n "${container_arn}" ] && [ "${container_arn}" != "None" ]; then
                local short_container_arn=$(echo "${container_arn}" | awk -F'/' '{print $NF}')
                ec2_instance=$(grep "^${short_container_arn}=" "${ec2_lookup_file}" 2>/dev/null | cut -d'=' -f2)
            fi

            # Parse service name from group
            local svc_name="${group:-standalone}"
            if [[ "${svc_name}" == service:* ]]; then
                svc_name="${svc_name#service:}"
            fi

            # Set exec indicator
            if [[ "${exec_status}" == "True" ]]; then
                exec_indicator="YES"
            fi

            # Write to lookup file (pipe-delimited for easy parsing)
            echo "${task_id}|${short_task_id}|${last_status}|${desired_status}|${task_def}|${health_status}|${group}|${launch_type}|${ec2_instance}|${exec_indicator}|${container_name}" >> "${preview_lookup_file}"

            # Format for main fzf display with fixed-width columns for table-like appearance
            # TASK_ID(12) SERVICE(60) LAUNCH(8) EXEC(4) STATUS(10) CONTAINER(20) TASK_ARN(hidden)
            printf "%-12s %-60s %-8s %-4s %-10s %-20s %s\n" "${short_task_id}" "${svc_name:0:60}" "${launch_type}" "${exec_indicator}" "${last_status}" "${container_name:0:20}" "${task_arn}"
        done <<< "${task_details}"
    )

    rm -f "${ec2_lookup_file}"

    # Step 6: Present task selection with fzf
    local formatted_header="$(printf '%-12s %-60s %-8s %-4s %-10s %-20s' 'TASK_ID' 'SERVICE' 'LAUNCH' 'EXEC' 'STATUS' 'CONTAINER')"
    local selected_task=$(echo "${formatted_tasks}" | \
        fzf --delimiter=' ' \
        --prompt="Select task> " \
            --header="${formatted_header}" \
            --preview="
                # Extract short_task_id from current line (first word, trimmed)
                short_task_id=\$(echo {} | awk '{print \$1}')
                # Look up task details using awk to match the short task_id in field 2
                awk -F'|' -v sid=\"\$short_task_id\" '\$2 == sid {
                    printf \"\033[1;36mTASK_ID:\033[0m %s\n\", \$1
                    printf \"\033[1;33mStatus:\033[0m %s\n\", \$3
                    printf \"\033[1;33mDesired Status:\033[0m %s\n\", \$4
                    printf \"\033[1;33mTask Definition:\033[0m %s\n\", \$5
                    printf \"\033[1;33mHealth Status:\033[0m %s\n\", \$6
                    printf \"\033[1;33mGroup:\033[0m %s\n\", \$7
                    printf \"\033[1;33mLaunch Type:\033[0m %s\n\", \$8
                    if (\$9 != \"\") {
                        printf \"\033[1;33mInstance ID:\033[0m %s\n\", \$9
                    } else {
                        printf \"\033[1;33mInstance ID:\033[0m FARGATE\n\"
                    }
                    printf \"\033[1;33mECS Exec:\033[0m %s\n\", \$10
                    printf \"\033[1;33mContainer:\033[0m %s\n\", \$11
                }' ${preview_lookup_file}
            " \
            --height=70% --preview-window=right:45%)

    rm -f "${preview_lookup_file}"

    if [ -z "${selected_task}" ]; then
        echo "No task selected."
        return
    fi

    # Parse the selected task (space-separated formatted output)
    local selected_short_task_id=$(echo "${selected_task}" | awk '{print $1}')
    local selected_container=$(echo "${selected_task}" | awk '{print $6}')
    local selected_task_arn=$(echo "${selected_task}" | awk '{print $7}')
    local selected_task_id=$(_extract_task_id "${selected_task_arn}")

    # Get task execution info
    local task_info=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-tasks \
        --cluster "${cluster_name}" \
        --tasks "${selected_task_arn}" \
        --query 'tasks[0].[enableExecuteCommand,launchType]' \
        --output text)

    local exec_enabled=$(echo "${task_info}" | awk -F'\t' '{print $1}')
    local launch_type=$(echo "${task_info}" | awk -F'\t' '{print $2}')

    # Step 7: Execute appropriate command
    local command_to_run=""

    if [[ "${exec_enabled}" == "True" ]]; then
        # Path A: Use ECS Execute Command
        echo "Starting ECS Execute Command session..."
        command_to_run="aws ${aws_profile_arg} --region=${aws_region} ecs execute-command \
            --cluster ${cluster_name} \
            --task ${selected_task_id} \
            --container ${selected_container} \
            --command \"/bin/sh\" \
            --interactive"
    else
        # Path B: Fall back to SSM on the EC2 instance (only for EC2 launch type)
        if [[ "${launch_type}" == "EC2" ]]; then
            # Get EC2 instance ID from container instance ARN
            local container_instance_arn=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-tasks \
                --cluster "${cluster_name}" \
                --tasks "${selected_task_arn}" \
                --query 'tasks[0].containerInstanceArn' \
                --output text)

            if [ -n "${container_instance_arn}" ] && [ "${container_instance_arn}" != "None" ]; then
                local ec2_instance_id=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-container-instances \
                    --cluster "${cluster_name}" \
                    --container-instances "${container_instance_arn}" \
                    --query 'containerInstances[0].ec2InstanceId' \
                    --output text)

                if [ -n "${ec2_instance_id}" ]; then
                    echo "ECS Exec not enabled. Preparing SSM session to EC2 instance ${ec2_instance_id}..."
                    echo ""
                    echo "Container info:"
                    echo "  Name: ${selected_container}"
                    echo "  Task ID: ${selected_task_id}"
                    echo ""
                    echo "To find the container once connected:"
                    echo "  docker ps | grep ${selected_container}"
                    echo "  docker exec -it \$(docker ps -q -f name=${selected_container}) sh"
                    echo ""
                    command_to_run="aws ${aws_profile_arg} --region=${aws_region} ssm start-session --target ${ec2_instance_id}"
                else
                    echo "Error: Could not determine EC2 instance ID for container instance."
                    return
                fi
            else
                echo "Error: Task does not support ECS Execute Command."
                if [[ "${launch_type}" == "FARGATE" ]]; then
                    echo "Task is running on Fargate - SSM fallback not available."
                else
                    echo "Enable ECS Execute Command on the task definition or service to use this helper."
                fi
                return
            fi
        else
            echo "Error: Task does not support ECS Execute Command."
            if [[ "${launch_type}" == "FARGATE" ]]; then
                echo "Task is running on Fargate - SSM fallback not available."
            else
                echo "Enable ECS Execute Command on the task definition or service to use this helper."
            fi
            return
        fi
    fi

    BUFFER="${command_to_run}"
    if zle; then
        zle accept-line
    else
        print -z "$BUFFER"
    fi

    if zle; then
        zle clear-screen
    fi
}
zle -N ecstask
