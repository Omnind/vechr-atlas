#!/bin/bash

source ./scripts/functions.sh

printf "${BLUE}"
echo "---------------------------------"
echo "--      Start All Container     --"
echo "---------------------------------"
printf "${NC}\n"

# Stop all task if docker daemon is not active
check_docker_active

printf "${PURPLE}"
echo "Starting docker engine..."
printf "${NC}"

# Get .env
if [ ! -f ".env" ]; then
	printf "${RED}[Check Requirement] File .env is not found${NC}\n"
fi 

printf "${BROWN}Load environment configurations${NC}\n"
while read line; do
    export $line
done < .env

CONTAINER_SETUP_LISTS=""

# Get apps from environment
while IFS=',' read -ra APPS; do
	for i in "${APPS[@]}"; do
	  applications+=($i)

	  case $i in
	  	tango)
			# Do nothing
	  		;;
	  	*)
			CONTAINER_SETUP_LISTS+="$i "
	  		;;
	  esac
	  
	done
done <<< "$APP_LISTS"

# Include base container
CONTAINER_SETUP_LISTS+="$CONTAINER_BASE "

docker-compose up -d $CONTAINER_SETUP_LISTS

echo ""
printf "${GREEN}"
echo "------ Machine is on running now. -------"
printf "${NC}"