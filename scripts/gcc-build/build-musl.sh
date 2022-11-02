#!/usr/bin/env bash
# shellcheck disable=SC1073
# shellcheck disable=SC2188
# [Modified the Musl-Cross-Make by Rich Felker](https://github.com/richfelker/musl-cross-make)
# This is the second generation of musl-cross-make, a fast, simple, but advanced makefile-based approach for producing musl-targeting cross compilers
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
debug() {
    PFX="INFO"
    printf '%s\n' "${PFX} ${*}"
}
# × × VARIABLES × × #
GIT_REPO_MUSL="https://github.com/richfelker/musl-cross-make"
# Some of the available target architectures
# i486-linux-musl
# x86_64-linux-musl
# arm-linux-musleabi
# arm-linux-musleabihf
# sh2eb-linux-muslfdpic
TARGET="arm-linux-musleabi"
CONF="./config.mak"
MAKFILE="./Makefile"
CURRENT_DIR="$(pwd)"
OUTPUT="${CURRENT_DIR}/cross"
CONFIGF="${CURRENT_DIR}/config.mak"
BUILD_DIR="${CURRENT_DIR}/build"
MUSL_DIR="${BUILD_DIR}/musl-cross-make"
# × × × × × × × × × × × × × × × × × × # 
debug "Creating $BUILD_DIR"
mkdir -p "$BUILD_DIR"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × #
debug "Cloning musl-cross-make"
git clone "$GIT_REPO_MUSL"
# × × × × × × × × × × × × × × × × × × #
debug "Copying $CONFIGF to $MUSL_DIR"
cp "$CONFIGF" "$MUSL_DIR"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $MUSL_DIR"
cd "$MUSL_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × #
debug "Changing ISL mirror site to a responsive server"
sed -i 's|ISL_SITE = http://isl.gforge.inria.fr/|ISL_SITE = https://gcc.gnu.org/pub/gcc/infrastructure/|g' "$MAKFILE"
# × × × × × × × × × × × × × × × × × × #
debug "Setting target architecture to $TARGET"
#shellcheck disable=SC2016
sed -i '31a TARGET = '"$TARGET"'' "$CONF"
# × × × × × × × × × × × × × × × × × × #
debug "Setting output directory to $OUTPUT"
sed -i '32a OUTPUT = '"$OUTPUT"'' "$CONF"
# × × × × × × × × × × × × × × × × × × #
debug "Compile and install to $OUTPUT"
make -j $(nproc)
make install
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $CURRENT_DIR"
cd "$CURRENT_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Removing $MUSL_DIR"
sudo rm -R "$MUSL_DIR"
debug "Done"
# × × × × × × × × × × × × × × × × × × #
exit 0
