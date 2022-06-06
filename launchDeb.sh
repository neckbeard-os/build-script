#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 
CONTAINER="build-script_build_1"
sudo docker exec -it "$CONTAINER" bash -c 'apt-get install -y --no-install-recommends git cron curl wget rsync apt-transport-https g++ make
scripts/gcc-build/build-musl.sh'

exit 0
