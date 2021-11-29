#!/bin/bash

if [ -z "$AWS_ASSUME_ACCOUNT_ID" ]
then
      echo "\$AWS_ASSUME_ACCOUNT_ID is empty, set into child organization account id"
      return 1
fi

if [ -z "$AWS_ASSUME_ROLE_NAME" ]
then
      echo "\$AWS_ASSUME_ROLE_NAME is empty, set into child organization role name"
      return 1
fi


OUT=$(aws sts assume-role --role-arn arn:aws:iam::${AWS_ASSUME_ACCOUNT_ID}:role/${AWS_ASSUME_ROLE_NAME} --role-session-name aaa);\
export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');\
export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');\
export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');\
export TF_VAR_AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID};\
export TF_VAR_AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY};\
export TF_VAR_SESSION_TOKEN=${AWS_SESSION_TOKEN}
