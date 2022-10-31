#!/usr/bin/env bash
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
CURRENT_DIR="$(pwd)"
BUILD_DIR="${CURRENT_DIR}/build"
OUTPUT_DIR="${CURRENT_DIR}/output"
CROSS_DIR="${CURRENT_DIR}/cross"
CONFIGF="${CURRENT_DIR}/config.mak"
MUSL_DIR="${BUILD_DIR}/musl-cross-make"
GIT_REPO_MUSL="https://github.com/richfelker/musl-cross-make"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
# trap 'cd {CURRENT_DIR}; sudo rm -R ${BUILD_DIR}; sudo rm -R ${OUTPUT_DIR}; sudo rm -R ${CROSS_DIR}' exit
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Creating ${BUILD_DIR} & ${OUTPUT_DIR} ${CROSS_DIR}"
mkdir -p "${BUILD_DIR}" "${OUTPUT_DIR}" "${CROSS_DIR}"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Changing directory to ${BUILD_DIR}"
cd "${BUILD_DIR}" || exit 1
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Cloning musl-cross-make"
git clone "${GIT_REPO_MUSL}"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Copying ${CONFIGF} to ${BUILD_DIR}/musl-cross-make"
cp "${CONFIGF}" "${MUSL_DIR}"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Changing directory to ${MUSL_DIR}"
cd "${MUSL_DIR}" || exit 1
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Changing ISL mirror site to a responsive server"
sed -i 's|ISL_SITE = http://isl.gforge.inria.fr/|ISL_SITE = https://gcc.gnu.org/pub/gcc/infrastructure/|g' "./Makefile"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
# To compile, run make. To install to $(OUTPUT), run make install.
# The default value for $(OUTPUT) is output
# After installing here you can move the cross compiler toolchain to another location as desired.
debug "Make musl-cross-compiler"
make
debug "Done"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
exit 0
