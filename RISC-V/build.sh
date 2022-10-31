#!/usr/bin/env bash
# 
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug() {
    PFX="INFO"
    printf '%s\n' "${PFX} ${*}"
}
# × × VARIABLES × × #
CURRENT_DIR="$(pwd)"
BUILD_DIR="${CURRENT_DIR}/riscv-gnu-toolchain"
OUTPUT_DIR="${CURRENT_DIR}/riscv"
PATH_BINARY="${CURRENT_DIR}/riscv/bin"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
export PATH="$PATH_BINARY:$PATH"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
trap 'cd ${CURRENT_DIR}; sudo rm -R ${BUILD_DIR}; sudo rm -R ${OUTPUT_DIR}' exit
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Creating ${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Cloning RISC-V GNU Toolchain"
git clone https://github.com/riscv/riscv-gnu-toolchain
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Changing directory to ${BUILD_DIR}"
cd "${BUILD_DIR}" || exit 1
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Start"
# make musl = musl libc 
# make linux = glibc
"${BUILD_DIR}"/configure --prefix="${OUTPUT_DIR}"
make linux
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #
debug "Done"
# × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × × #