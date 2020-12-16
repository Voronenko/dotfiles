#!/bin/bash

TAG=${1:-sts_windows_6}

#echo "Tagged $TAG:"

curl --header "PRIVATE-TOKEN: ${PRIVATE_GITLAB_TOKEN}" "https://gitlab.com/api/v4/runners?tag_list=${TAG}" | jq .
