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

function ecstaskenv() {
    emulate -L zsh -o noxtrace
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

    # Step 3: Get comprehensive task details (batched, max 100 tasks per API call)
    local task_arns_array=(${(f)task_arns})
    local task_count=${#task_arns_array[@]}
    local chunk_size=100
    local task_details=""
    local stderr_file=$(mktemp)
    local stdout_file=$(mktemp)

    local i=0
    while [ $i -lt $task_count ]; do
        local chunk=("${task_arns_array[@]:$i:$chunk_size}")
        aws ${aws_profile_arg} --region=${aws_region} ecs describe-tasks \
            --cluster "${cluster_name}" \
            --tasks "${chunk[@]}" \
            --query 'tasks[*].[taskArn,group,containerInstanceArn,enableExecuteCommand,lastStatus,desiredStatus,taskDefinitionArn,healthStatus,launchType,containers[0].name]' \
            --output text >"${stdout_file}" 2>"${stderr_file}"

        local chunk_exit=$?
        if [ $chunk_exit -ne 0 ]; then
            local chunk_stderr=$(<"${stderr_file}")
            echo "Failed to fetch task details." >&2
            echo "  Cluster: ${cluster_name}" >&2
            echo "  Region: ${aws_region}" >&2
            echo "  Exit code: ${chunk_exit}" >&2
            if [ -n "${chunk_stderr}" ]; then
                echo "  Error: ${chunk_stderr}" >&2
            fi
            rm -f "${stderr_file}" "${stdout_file}"
            return
        fi

        local chunk_result=$(<"${stdout_file}")
        if [ -n "${chunk_result}" ]; then
            if [ -n "${task_details}" ]; then
                task_details="${task_details}"$'\n'"${chunk_result}"
            else
                task_details="${chunk_result}"
            fi
        fi

        i=$((i + chunk_size))
    done

    rm -f "${stderr_file}" "${stdout_file}"

    if [ -z "${task_details}" ]; then
        echo "Failed to fetch task details." >&2
        echo "  NOTE: All API calls succeeded but returned empty (tasks may have terminated)" >&2
        return
    fi

    # Step 4: Build preview lookup file and formatted task list
    # Create a lookup file with format: task_id|short_task_id|last_status|desired_status|task_def|health_status|group|launch_type|exec_indicator|container_name
    local preview_lookup_file=$(mktemp)
    local formatted_tasks=""

    formatted_tasks=$(
        while IFS=$'\t' read -r task_arn group container_arn exec_status last_status desired_status task_def health_status launch_type container_name; do
            local task_id=$(_extract_task_id "${task_arn}")
            local short_task_id=$(_shorten_task_id "${task_id}")
            local exec_indicator="NO"

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
            echo "${task_id}|${short_task_id}|${last_status}|${desired_status}|${task_def}|${health_status}|${group}|${launch_type}|${exec_indicator}|${container_name}" >> "${preview_lookup_file}"

            # Format for main fzf display with fixed-width columns for table-like appearance
            # TASK_ID(12) SERVICE(60) LAUNCH(8) EXEC(4) STATUS(10) CONTAINER(20) TASK_ARN(hidden)
            printf "%-12s %-60s %-8s %-4s %-10s %-20s %s\n" "${short_task_id}" "${svc_name:0:60}" "${launch_type}" "${exec_indicator}" "${last_status}" "${container_name:0:20}" "${task_arn}"
        done <<< "${task_details}"
    )

    # Step 5: Present task selection with fzf
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
                    printf \"\033[1;33mECS Exec:\033[0m %s\n\", \$9
                    printf \"\033[1;33mContainer:\033[0m %s\n\", \$10
                }' ${preview_lookup_file}
            " \
            --height=70% --preview-window=right:45%)

    rm -f "${preview_lookup_file}"

    if [ -z "${selected_task}" ]; then
        echo "No task selected."
        return
    fi

    # Parse the selected task (space-separated formatted output)
    local selected_task_arn=$(echo "${selected_task}" | awk '{print $7}')
    local selected_task_id=$(_extract_task_id "${selected_task_arn}")

    # Step 6: Resolve the task definition ARN for the selected task
    echo "Fetching task definition ARN..."
    local task_def_arn=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-tasks \
        --cluster "${cluster_name}" \
        --tasks "${selected_task_arn}" \
        --query 'tasks[0].taskDefinitionArn' \
        --output text)

    if [ -z "${task_def_arn}" ] || [ "${task_def_arn}" = "None" ]; then
        echo "Error: Could not determine task definition ARN for task ${selected_task_id}." >&2
        return
    fi

    # Step 7: Check if task has multiple containers and require selection
    local all_containers=$(aws ${aws_profile_arg} --region=${aws_region} ecs describe-tasks \
        --cluster "${cluster_name}" \
        --tasks "${selected_task_arn}" \
        --query 'tasks[0].containers[].name' \
        --output json 2>/dev/null)

    local container_count=$(echo "${all_containers}" | jq 'length' 2>/dev/null)
    local container_arg=""

    if [ "${container_count}" -gt 1 ]; then
        echo "Task has ${container_count} containers:"
        local selected_container=$(echo "${all_containers}" | jq -r '.[]' | \
            fzf --prompt="Select container> " --height=30% --header="Available containers")

        if [ -z "${selected_container}" ]; then
            echo "No container selected."
            return
        fi
        container_arg="--container ${selected_container}"
    fi

    # Step 8: Stage the command that prints the task definition environment as name=value pairs
    local command_to_run="aws_taskdef_env ${container_arg} ${aws_profile_arg} --region=${aws_region} ${task_def_arn}"

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
zle -N ecstaskenv
