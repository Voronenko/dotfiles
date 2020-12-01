#! /bin/bash
export REGION=${AWS_DEFAULT_REGION:-eu-west-1}
export REGION=${AWS_REGION:-$REGION}
export REGION=${1:-$REGION}
echo logging into $REGION
`aws ecr get-login --region $REGION --no-include-email`
