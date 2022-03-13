#!/bin/bash

source ./scripts/functions.sh

# Stop all task if docker daemon is not active
check_docker_active

if [ -z $1 ]; then
    printf "${RED}"
    echo "Please provide the container name!!"
    printf "${NC}\n"
    exit;
fi

printf "${GREEN}"
echo "connecting to container $1..."

printf "${NC}\n"

CHECK=$(check_container_running "$1")

if [ $? == 1 ]; then
    docker logs --tail 100 -f "$1"
    exit
fi

printf "${RED}[Error] - Either container not exists or the container is not running${NC}\n\n"
