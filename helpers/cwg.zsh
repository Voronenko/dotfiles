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

    aws_profile_name=$(_load_aws_profile "$aws_profile_name")
    aws_region=$(_load_aws_region "$aws_region")

    if [[ -z "$aws_profile_name" || -z "$aws_region" ]]; then
        echo "AWS profile and region are required"
        return 1
    fi

    echo "Fetching CloudWatch groups..."

    # ---------- PREVIEW COMMAND ----------
    local preview_cmd="
      echo \"Loading logs for {}...\"
      start_ms=\$(($(date +%s) * 1000 - 5 * 60 * 1000))
      # Strip single quotes from the log group name using bash parameter expansion
      group=\"{}\"
      group=\"\${group#\\'}\"
      group=\"\${group%\\'}\"
      result=\$(aws --profile=\"$aws_profile_name\" --region=\"$aws_region\" \
        logs filter-log-events \
        --log-group-name \"\$group\" \
        --start-time \"\$start_ms\" \
        --max-items 20 \
        --query \"events[].message\" \
        --output text 2>&1)
      if [[ \$? -eq 0 ]]; then
        echo \"\$result\" | tail -n 20
      else
        echo \"Error fetching logs for [\$group]: \$result\"
        echo \"Debug: Raw group name: [{}]\"
      fi
    "

    local selected_group=$(
      aws --profile="$aws_profile_name" --region="$aws_region" \
        logs describe-log-groups \
        --query 'logGroups[].logGroupName' \
        --output text | tr '\t' '\n' |
      fzf \
        --prompt="Log group> " \
        --preview="$preview_cmd" \
        --preview-window=right:60%:wrap
    )

    if [[ -n "$selected_group" ]]; then
        echo "Starting time options:"
        local start_time=$(
          echo -e "0m\n5m\n10m\n15m\n30m\n60m\n2h\n4h\n8h\n1d" |
          fzf --prompt="Starting time> "
        )

        local start_option=""
        [[ -n "$start_time" && "$start_time" != "0m" ]] && start_option="--start=$start_time"

        BUFFER="cw tail -f ${selected_group} --no-color ${extra_args} ${start_option} | lnav"
        if zle; then
            zle accept-line
        else
            print -z "$BUFFER"
        fi
    fi

    zle && zle clear-screen
}
zle -N cwg

