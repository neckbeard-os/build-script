#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 
CONTAINER="build-script_build_1"
sudo docker exec -it "$CONTAINER" bash -c 'scripts/gcc-build/build-musl.sh'

exit 0
