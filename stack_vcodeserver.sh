#!/bin/bash

VOLUME="StackVCodeVol"
USER="alonzo"
CONTAINER="stack_vcode"

if ! docker volume ls | grep "$VOLUME"; then
    docker volume create "$VOLUME"
fi

if  docker ps -a | grep "$CONTAINER"; then
    docker start "$CONTAINER"
else
    docker run -d -p 8080:8080 -v "$VOLUME":"/home/$USER" --name "$CONTAINER" stack-code
fi