#!/bin/sh
  if [ -z "$1" ]
  then
    echo "Pass image name as param 1"
    return 1
  fi

  IMAGE_ID=$(docker images -q $1)

  if [ -z "$IMAGE_ID" ]
  then
    echo "No Image named $1 found"
    return 0
  fi

  echo docker images | grep ${IMAGE_ID} | awk '{print $1 ":" $2}' | xargs docker rmi
  docker images | grep ${IMAGE_ID} | awk '{print $1 ":" $2}' | xargs docker rmi

