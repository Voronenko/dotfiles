#! /bin/bash
export REGION=${AWS_DEFAULT_REGION:-eu-west-1}
export REGION=${AWS_REGION:-$REGION}
export REGION=${1:-$REGION}

ACCOUNT_ID=$(aws ec2 describe-security-groups --group-names 'Default' --query 'SecurityGroups[0].OwnerId' --output text)

echo logging into $REGION
echo consider switching to https://github.com/awslabs/amazon-ecr-credential-helper

aws ecr get-login-password \
    --region ${REGION} \
| docker login \
    --username AWS \
    --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
