#! /bin/bash
aws ecr get-login --region ${1:-AWS_DEFAULT_REGION} --no-include-email
