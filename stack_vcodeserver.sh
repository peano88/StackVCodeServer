#!/bin/bash

VOLUME="StackVCodeVol"
USER="alonzo"

if ! docker volume ls | grep "$VOLUME"; then
    docker volume create "$VOLUME"
fi

docker run -d -p 8080:8080 -v "$VOLUME":"/home/$USER" --name stack_vcode stack-code