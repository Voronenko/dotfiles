#!/bin/bash

local aws_profile=$1
region_data=$(cat ~/.aws/config | grep "\[profile $aws_profile\]" -A4 | grep -B 15 "^$")
if [ -z "$region_data" ]
then
  echo "aws profile $1 not found for loading"
  exit 1
fi
AWS_DEFAULT_REGION="$(echo $region_data | grep region | cut -f2 -d'=' | tr -d ' ')"
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
export AWS_PROFILE=${aws_profile}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
export AWS_DEFAULT_PROFILE=${aws_profile}
export TF_VAR_AWS_PROFILE=${AWS_PROFILE}
export TF_VAR_AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
