#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 
BUILD_DIR=/build
# CROSS_DIR=/opt/cross
CONFIGF="scripts/gcc-build/config.mak"
MUSL_DIR="$BUILD_DIR/musl-cross-make"

printf '%s\n' "Creating $BUILD_DIR"
mkdir -p "$BUILD_DIR"

printf '%s\n' "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1

printf '%s\n' "Cloning musl-cross-make"
git clone https://github.com/richfelker/musl-cross-make

printf '%s\n' "Copying $CONFIGF to $BUILD_DIR/musl-cross-make"
cp "/docker/scripts/gcc-build/config.mak" "$MUSL_DIR"

printf '%s\n' "Changing directory to $MUSL_DIR"
cd "$MUSL_DIR" || exit 1

printf '%s\n' "Changing isl mirror site to a responsive server"
sed -i 's/ISL_SITE = http:\/\/isl.gforge.inria.fr\//ISL_SITE = https:\/\/gcc.gnu.org\/pub\/gcc\/infrastructure\//g' "./Makefile"

# The available target architectures
# The currently set one is x84_64-linux-musl, use sed -i and change it in config.mak before copying it
# i486="TARGET = i486-linux-musl"
# x64="TARGET = x86_64-linux-musl"
# armeabi="TARGET = arm-linux-musleabi"
# armeabihf"TARGET = arm-linux-musleabihf"
# sh2eb="TARGET = sh2eb-linux-muslfdpic"
printf '%s\n' "Setting architecture"
#shellcheck disable=SC2016
sed -i 's/# ${x64}/${x64}/g' "./config.mak"

printf '%s\n' "Make musl cross-compiler"

make

printf '%s\n' "Complete!"

exit 0
