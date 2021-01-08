#!/bin/bash
ACTION=""
VOLUME="StackVCodeVol"
USER="alonzo"
CONTAINER="stack_vcode"
IMAGE="peano88/stack-code"

function show_help {
    echo -e "\
stack_vcodeserver \n\
USAGE: stack_vcodeserver [OPTIONS]... COMMAND where \n\
OPTIONS:\n\
\t-h|--help: \t\t\t show this help\n\
\t-v|--volume VOLUME: \t\t use VOLUME as volume name. Default is \"StackVCodeVol\"\n\
\t-i|--image IMAGE: \t\t use IMAGE as image name. Default is \"peano88/stack-code\"\n\
\t-c|--container CONTAINER: \t use CONTAINER as container name. Default is \"stack_vcode\"\n\
\t-u|--container USER: \t\t use USER as the running user. Default is \"alonzo\"\n\
COMMAND:\n\
\texec: \t\t\t\t run the container\n\
\tbuild: \t\t\t\t recreate the container (and run it)\n\
\tstop: \t\t\t\t stop the container\n\
"
}

function options {
    while [ -n "$1" ]
    do
        case "$1" in
            -h|--help)
                ACTION="help"
                return 0
                ;;
            -v|--volume)
                VOLUME="$2"
                if [[ $VOLUME =~ ^- ]]; then
                    echo "Volume name not specified"
                    return 1
                fi
                shift    
            ;;
            -u|--user)
                USER="$2"
                if [[ $USER =~ ^- ]]; then
                    echo "User name not specified"
                    return 1
                fi
                shift    
            ;;
            -c|--container)
                CONTAINER="$2"
                if [[ $CONTAINER =~ ^- ]]; then
                    echo "Container name not specified"
                    return 1
                fi
                shift    
            ;;
            -i|--image)
                IMAGE="$2"
                if [[ $IMAGE =~ ^- ]]; then
                    echo "Image name not specified"
                    return 1
                fi
                shift    
            ;;
            -*)
                echo "Option not recognized: $1"
                return 1
            ;;
            *)
                ACTION="$1"
        esac
        shift
    done
    return 0
}

function volume {
    if ! docker volume ls | grep -q "$VOLUME"; then
        docker volume create "$VOLUME"
    fi
}

function run_container {
    if  docker ps -a | grep -q "$CONTAINER"; then
        docker start "$CONTAINER"
    else
        build_container
    fi
}

function stop_container {
    docker stop "$CONTAINER"
}

function build_container {
    volume 
    if  docker ps -a | grep -q "$CONTAINER"; then
        docker stop "$CONTAINER"
        docker rm "$CONTAINER"
    fi
    docker run -d -p 8080:8080 -v "$VOLUME":"/home/$USER" --name "$CONTAINER" "$IMAGE"
}

if ! options $@; then
    exit 1
fi

case "$ACTION" in     
    help)
        show_help
    ;;
    exec)
        run_container
    ;;
    build)
        build_container
    ;;
    stop)
        stop_container
    ;;
    *)
        if [ -z $ACTION ]; then 
            echo "No command provided"
        else 
            echo "Command $ACTION not valid"    
        fi
        exit 1
    ;;
esac