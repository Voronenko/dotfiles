#!/bin/bash
set -euo pipefail

# -----------------------------
# Region detection (your logic)
# -----------------------------
REGION=${AWS_DEFAULT_REGION:-ap-southeast-1}
REGION=${AWS_REGION:-$REGION}
REGION=${1:-$REGION}

# -----------------------------
# Detect if running on EC2
# -----------------------------
is_ec2() {
    curl -s --connect-timeout 0.2 http://169.254.169.254/latest/meta-data/ > /dev/null 2>&1
}

# -----------------------------
# Get Account ID (EC2 or Local)
# -----------------------------
get_account_id() {
    if is_ec2; then
        # EC2 mode → use IMDSv2 (no IAM permissions needed)
        TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
            -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") || true

        ACCOUNT_ID=$(curl -s -H "X-aws-ec2-metadata-token: ${TOKEN}" \
            http://169.254.169.254/latest/dynamic/instance-identity/document \
            | grep accountId | cut -d'"' -f4)

        if [[ -n "$ACCOUNT_ID" ]]; then
            echo "$ACCOUNT_ID"
            return 0
        fi
    fi

    # Local mode → use AWS CLI + active profile
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || true)

    if [[ -z "$ACCOUNT_ID" ]]; then
        echo "ERROR: Could not determine AWS Account ID (neither EC2 metadata nor aws sts worked)" >&2
        exit 1
    fi

    echo "$ACCOUNT_ID"
}

ACCOUNT_ID=$(get_account_id)

# -----------------------------
# Log in to ECR
# -----------------------------
echo "Logging into region: $REGION"
echo "Using account: $ACCOUNT_ID"
echo "Consider switching to: https://github.com/awslabs/amazon-ecr-credential-helper"

aws ecr get-login-password --region "${REGION}" \
| docker login \
    --username AWS \
    --password-stdin "${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
