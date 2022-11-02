#!/usr/bin/env bash
# 
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
# GNU Toolchain for RISC-V architecture
# 
# WARNING: git clone takes around 6.65 GB of disk and download size
# 
# × × × DEPENDENCIES × × × # (Debian)
# autoconf automake autotools-dev
# libmpc-dev libmpfr-dev libgmp-dev
# libtool zlib1g-dev libexpat-dev
# curl python3 gawk build-essential
# bison flex texinfo gperf patchutils bc 
# × × × × × × × × × × × × × × × × × × #
# If you have started a new GitHub Codespace container, run the command below to successfully complete the build.
# sudo apt-get update -y && sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
# × × × × × × × × × × × × × × × × × × #
debug() {
    PFX="INFO"
    printf '%s\n' "${PFX} ${*}"
}
# × × × VARIABLES × × × #
CURRENT_DIR="$PWD"
BUILD_DIR="${CURRENT_DIR}/riscv-gnu-toolchain"
OUTPUT_DIR="${CURRENT_DIR}/riscv"
PATH_BINARY="${CURRENT_DIR}/riscv/bin"
RISCV_GNU_TOOLCHAIN="https://github.com/riscv/riscv-gnu-toolchain"
# × × × × × × × × × × × × × × × × × × #
export PATH="${PATH_BINARY}:${PATH}"
# × × × × × × × × × × × × × × × × × × #
#trap 'cd ${CURRENT_DIR}; sudo rm -R ${BUILD_DIR}; sudo rm -R ${OUTPUT_DIR}' exit
# × × × × × × × × × × × × × × × × × × #
debug "Creating $OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"
# × × × × × × × × × × × × × × × × × × #
# WARNING: git clone takes around 6.65 GB of disk and download size
debug "Cloning RISC-V GNU Toolchain"
git clone "$RISCV_GNU_TOOLCHAIN"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × #
# Use Source Tree Other Than riscv-gnu-toolchain
# https://github.com/riscv-collab/riscv-gnu-toolchain#use-source-tree-other-than-riscv-gnu-toolchain
# 
# riscv-gnu-toolchain also support using out-of-tree source to build toolchain, there is couple configure option to specify the source tree of each submodule/component.
# For example you have a gcc in $HOME/gcc, use --with-gcc-src can specify that:
# 
# ./configure --with-gcc-src=$HOME/gcc
# 
# Here is the list of configure option for specify source tree:
# 
# --with-gcc-src
# --with-binutils-src
# --with-newlib-src
# --with-glibc-src
# --with-musl-src
# --with-gdb-src
# --with-linux-headers-src
# --with-qemu-src
# --with-spike-src
# --with-pk-src
# × × × × × × × × × × × × × × × × × × #
# make musl = Musl libc 
# make linux = GNU glibc
# × × × × × × × × × × × × × × × × × × #
debug "Make cross compiler"
"$BUILD_DIR"/configure --prefix="$OUTPUT_DIR"
make -j $(nproc) musl
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $CURRENT_DIR"
cd "$CURRENT_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Removing toolchain repository in $BUILD_DIR"
sudo rm -R "$BUILD_DIR"
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Finished"
# × × × × × × × × × × × × × × × × × × #
