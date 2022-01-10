#!/bin/bash
# @ZendaiOwl

BUILD_DIR=/docker/build
CROSS_DIR=/opt/cross
CONFIGF=docker/scripts/gcc-build/config.mak
MUSL_DIR=docker/build/musl-cross-make

# The available target architectures
# The currently set one is x84_64-linux-musl, use sed -i and change it in config.mak before copying it
# i486="TARGET = i486-linux-musl"
# x64="TARGET = x86_64-linux-musl"
# armeabi="TARGET = arm-linux-musleabi"
# armeabihf"TARGET = arm-linux-musleabihf"
# sh2eb="TARGET = sh2eb-linux-muslfdpic"
printf '%s\n' "Setting architecture"
sed -i 's/# ${x64}/${x64}/g' "$CONFIGF"

printf '%s\n' "Creating $BUILD_DIR"
mkdir -p "$BUILD_DIR"

printf '%s\n' "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR"

printf '%s\n' "Cloning musl-cross-make"
git clone https://github.com/richfelker/musl-cross-make

printf '%s\n' "Copying $CONFIGF to $BUILD_DIR/musl-cross-make"
cp "$CONFIGF" "$MUSL_DIR"

printf '%s\n' "Changing directory to $MUSL_DIR"
cd musl-cross-make

printf '%s\n' "Changing isl mirror site to a responsive server"
sed -i 's/ISL_SITE = http:\/\/isl.gforge.inria.fr\//ISL_SITE = https:\/\/gcc.gnu.org\/pub\/gcc\/infrastructure\//g' Makefile

printf '%s\n' "Make musl cross-compiler"

make

printf '%s\n' "Complete!"

exit
