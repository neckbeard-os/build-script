#!/usr/bin/env bash
# shellcheck disable=SC1073
# shellcheck disable=SC2188 
<<COMMENT
[Modified the Musl-Cross-Make by Rich Felker](https://github.com/richfelker/musl-cross-make)
This is the second generation of musl-cross-make, a fast, simple, but advanced makefile-based approach for producing musl-targeting cross compilers

@Victor-ray, S. <victorray91@pm.me> 
(https://github.com/ZendaiOwl)
COMMENT
#×× DEBUG
debug() {
    PFX="INFO ${*}"
    printf '%s\n' "${PFX}"
}
#×× VARIABLES 
BUILD_DIR=/build
# CROSS_DIR=/opt/cross
CONFIGF="scripts/gcc-build/config.mak"
MUSL_DIR="${BUILD_DIR}/musl-cross-make"
GIT_REPO_MUSL="https://github.com/richfelker/musl-cross-make"
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
debug "Creating ${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
debug "Changing directory to ${BUILD_DIR}"
cd "${BUILD_DIR}" || exit 1
debug "Cloning musl-cross-make"
git clone "${GIT_REPO_MUSL}"
debug "Copying $CONFIGF to ${BUILD_DIR}/musl-cross-make"
cp "/docker/scripts/gcc-build/config.mak" "${MUSL_DIR}"
debug "Changing directory to ${MUSL_DIR}"
cd "${MUSL_DIR}" || exit 1
debug "Changing isl mirror site to a responsive server"
sed -i 's/ISL_SITE = http:\/\/isl.gforge.inria.fr\//ISL_SITE = https:\/\/gcc.gnu.org\/pub\/gcc\/infrastructure\//g' "./Makefile"
# The available target architectures
# The currently set one is x84_64-linux-musl, use sed -i and change it in config.mak before copying it
# i486="TARGET = i486-linux-musl"
# x64="TARGET = x86_64-linux-musl"
# armeabi="TARGET = arm-linux-musleabi"
# armeabihf"TARGET = arm-linux-musleabihf"
# sh2eb="TARGET = sh2eb-linux-muslfdpic"
debug "Setting architecture"
#shellcheck disable=SC2016
sed -i 's/# ${x64}/${x64}/g' "./config.mak"
debug "Make musl cross-compiler"
make
debug "Completed Musl Cross-Compiler!"

exit 0
