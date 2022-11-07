#!/usr/bin/env bash
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com>
# https://github.com/ZendaiOwl
# 

sudo docker-compose up --build -d || exit 1
./launchFed.sh 
# echo "Docker image is built, run launchDeb.sh or launch Fed.sh"

exit 0
