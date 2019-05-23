#!/bin/bash

IMAGE=${1:-docker:latest}

docker run -it -v /var/run/docker.sock:/var/run/docker.sock $IMAGE sh
