#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 

sudo docker-compose up --build -d || exit 1

./launch.sh || exit 1

exit 0
