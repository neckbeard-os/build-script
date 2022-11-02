#!/usr/bin/env bash
# × × × × × × × × × × × × × × × × × × #
# shellcheck disable=SC1073
# shellcheck disable=SC2188
# 
# [Modified the Musl-Cross-Make by Rich Felker](https://github.com/richfelker/musl-cross-make)
# This is the second generation of musl-cross-make, a fast, simple, but advanced makefile-based approach for producing musl-targeting cross compilers
#
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
debug() {
    PFX="INFO"
    printf '%s\n' "${PFX} ${*}"
}
# × × VARIABLES × × #
GIT_REPO_MUSL="https://github.com/richfelker/musl-cross-make"
TARGET="riscv64-linux-musl"
CURRENT_DIR="$PWD"
BUILD_DIR="${CURRENT_DIR}/build"
OUTPUT_DIR="${CURRENT_DIR}/output"
CONFIGF="${CURRENT_DIR}/config.mak"
MUSL_DIR="${BUILD_DIR}/musl-cross-make"
CONF="./config.mak"
# × × × × × × × × × × × × × × × × × × #
# trap 'cd {CURRENT_DIR}; sudo rm -R ${BUILD_DIR}; sudo rm -R ${OUTPUT_DIR}; sudo rm -R ${CROSS_DIR}' exit
# × × × × × × × × × × × × × × × × × × #
debug "Creating $BUILD_DIR & $OUTPUT_DIR"
mkdir -p "$BUILD_DIR" "$OUTPUT_DIR"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × #
debug "Cloning musl-cross-make"
git clone "$GIT_REPO_MUSL"
# × × × × × × × × × × × × × × × × × × #
debug "Copying $CONFIGF to ${BUILD_DIR}/musl-cross-make"
cp "$CONFIGF" "$MUSL_DIR"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $MUSL_DIR"
cd "$MUSL_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × #
debug "Changing ISL mirror site to a responsive server"
sed -i 's|ISL_SITE = http://isl.gforge.inria.fr/|ISL_SITE = https://gcc.gnu.org/pub/gcc/infrastructure/|g' "./Makefile"
# × × × × × × × × × × × × × × × × × × #
# To compile, run make. 
# To install to $(OUTPUT), run make install.
# The default value for $(OUTPUT) is output
# After installing here you can move the cross compiler toolchain to another location as desired.
#shellcheck disable=SC2016
debug "Setting target architecture to $TARGET"
sed -i '31a TARGET = '"$TARGET"'' "$CONF"
# × × × × × × × × × × × × × × × × × × #
debug "Setting output directory to $OUTPUT_DIR"
sed -i '32a OUTPUT = '"$OUTPUT_DIR"'' "$CONF"
# × × × × × × × × × × × × × × × × × × #
debug "Make musl-cross-compiler"
make -j $(nproc)
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Install musl-cross-compiler to $OUTPUT_DIR"
make -j $(nproc) install
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Returning to starting directory"
cd "$CURRENT_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Removing $BUILD_DIR"
sudo rm -R "$BUILD_DIR"
debug "Done"
# × × × × × × × × × × × × × × × × × × #
exit 0
