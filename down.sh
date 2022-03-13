#!/bin/bash

source ./scripts/functions.sh

printf "${BLUE}"
echo "---------------------------------"
echo "--      Stop All Container     --"
echo "---------------------------------"
printf "${NC}\n"

# Stop all task if docker daemon is not active
check_docker_active

printf "${PURPLE}"
echo "Stopping docker engine..."
printf "${NC}"

docker-compose stop

echo ""

printf "${GREEN}"
echo "All Container Stopped"
printf "${NC}"
echo ""
