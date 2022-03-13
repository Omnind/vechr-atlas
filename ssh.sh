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
echo "connecting to container..."
printf "${NC}\n"

CHECK=$(check_container_running "$1")

if [ $? == 1 ]; then
    docker exec -it "$1" sh
    exit
fi

printf "${RED}[Error] - Container doesn't exists or the container is not running${NC}\n\n"