#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 

sudo docker-compose up --build -d || exit 1
./launchFed.sh 
# echo "Docker image is built, run launchDeb.sh or launch Fed.sh"

exit 0
