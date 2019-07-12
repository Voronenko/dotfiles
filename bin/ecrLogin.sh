#! /bin/bash
`aws ecr get-login --region ${1:-eu-west-1} --no-include-email`
