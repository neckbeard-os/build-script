#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 
# To be launched from a Fedora Host on which the container is being built.
# 
CONTAINER="build-script_build_1"

sudo docker exec -it "$CONTAINER" bash -c 'scripts/gcc-build/build-musl.sh'

exit 0
