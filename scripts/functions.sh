#!/bin/bash

# Color Var
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'
SCRIPTPATH=$(pwd -P)

# Pause process
function pause() {
   read -p "$*"
}

function join_by { local IFS="$1"; shift; echo "$*"; }

function confirmation() {
    printf "${RED}$* ${NC}\n"
    printf "${BROWN}Just type the number of your selection choice!!${NC}\n"
    select yn in "Yes, just do it" "No, please take me out"; do
        case $yn in
            "Yes, just do it" )
                    return 1
                    break
                ;;
            "No, please take me out" )
                    printf "${GREEN}Okaayyy then.... Good Bye.${NC}\n"
                    exit
                ;;
            * ) printf "${PURPLE}That is not an answer.${NC}\n";;
        esac
    done
}

# Create directory if not exists
function create_dir() {
    if [[ ! -e $dir ]]; then
        printf "${GREEN}[Checking Directory]${NC} $*\n"
        mkdir -p "$*"
    elif [[ ! -d $* ]]; then
        printf "$* ${RED}already exists but is not a directory${NC}\n" 1>&2
    fi
}

# Check if directory is empty
function is_empty_dir() {
    if [ "$(ls -A $1)" ]; then
        return 1
    else
        return 0
    fi
}

# Check is docker machine active
function check_docker_active() {
    docker_info=$(docker info 2>&1)

    if [[ $docker_info == *"connect to the Docker daemon"* ]]; then
            printf "${RED}"
            echo "Error found :"
            echo docker_info
            echo ""
            echo "Quit all tasks"
            printf "${NC}"
            exit
    fi

    printf "${BROWN}[Check Requirement] Docker is installed${NC} $*\n"
}

# Check is container exist or running
function check_container_running() {
    CONTAINER=$1

    RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)

    if [ "$RUNNING" == "true" ]; then
        return 1
    else
        return 0
    fi
}

printf "${GREEN}\n"

echo "kreMES by: kreMES Teams :)"

printf "${NC}\n"