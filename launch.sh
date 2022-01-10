#!/bin/bash
# @ZendaiOwl
PACKAGES="git cron curl wget rsync apt-transport-https g++ make"
CONTAINER="build-script_build_1"
sudo docker exec -it "$CONTAINER" bash \
apt-get install -y --no-install-recommends "$PACKAGES" \
scripts/gcc-build/build-musl.sh

exit
