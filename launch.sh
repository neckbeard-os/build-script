#!/bin/bash
CONTAINER="build-script_build_1"
sudo docker exec -it "$CONTAINER" sh -c docker/scripts/gcc-build/build-musl.sh

exit
