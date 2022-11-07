#!/usr/bin/env bash
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com>
# https://github.com/ZendaiOwl
# 
# To be launched from a Fedora Host on which the container is being built.
# 
CONTAINER="build-script_build_1"

# sudo docker exec -it "$CONTAINER" bash -c "scripts/gcc-build/build-musl.sh"

# sudo docker exec -it "$CONTAINER" bash -c "scripts/gcc-build/build-gcc-aarch64.sh"

sudo docker exec -it "$CONTAINER" bash -c "scripts/gcc-build/build-gcc-amd64.sh"

exit 0
