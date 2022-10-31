#!/usr/bin/env bash
# shellcheck disable=SC1073
# shellcheck disable=SC2188
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
# Builds a cross-compiler for AArch64bit instructionset (ARM64bit)
# I followed this article/blog post and modified it 
# https://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/
# 
# https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.sign - signature for the kernel
# 
debug() {
    PFX="GCC BUILD INFO"
    printf '%s\n' "${PFX} ${*}"
}
set -euo pipefail
debug "Starting build script for GCC Cross-Compiler"
### × DIRECTORIES × ###
BUILD_DIR="/docker/build"
CROSS_DIR="/opt/cross"
BUILD_BINUTILS="${BUILD_DIR}/build-binutils"
BUILD_GCC="${BUILD_DIR}/gcc-build"
BUILD_GLIBC="${BUILD_DIR}/build-glibc"
# × × × × × × × × × × × × × × × × × × # 
debug "Creating directories: ${BUILD_DIR} ${CROSS_DIR} ${BUILD_BINUTILS} ${BUILD_GCC} ${BUILD_GLIBC}"
mkdir -p "${BUILD_DIR}" "${CROSS_DIR}" "${BUILD_BINUTILS}" "${BUILD_GCC}" "${BUILD_GLIBC}"
# chown "$(whoami)" "${CROSS_DIR}"
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to ${BUILD_DIR}"
cd "${BUILD_DIR}" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Download: BINUTILS GCC KERNEL GLIBC MPFR GMP MPC ISL CLOOG"
wget https://mirrors.kernel.org/gnu/binutils/binutils-2.37.tar.xz || exit 1
wget https://mirrors.kernel.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.xz || exit 1
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.xz || exit 1
wget https://mirrors.kernel.org/gnu/glibc/glibc-2.34.tar.xz || exit 1
wget https://mirrors.kernel.org/gnu/mpfr/mpfr-4.1.0.tar.xz || exit 1
# wget https://mirrors.tripadvisor.com/gnu/gmp/gmp-6.2.0.tar.bz2 || exit 1
wget https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz || exit 1
wget http://mirror.us-midwest-1.nexcess.net/gnu/mpc/mpc-1.2.1.tar.gz || exit 1
wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2 || exit 1
wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
### × [ Build Steps ] × ###
# Extract all the source packages.
debug "Extract source packages"
for f in *.tar*; do tar xf "${f}"; done
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Remove source packages"
for f in *.tar*; do rm "${f}"; done
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
### × VARIABLES × ###
BINUTILS="${BUILD_DIR}/binutils-2.37"
GCC="${BUILD_DIR}/gcc-10.3.0"
KERNEL="${BUILD_DIR}/linux-5.15.12"
GLIBC="${BUILD_DIR}/glibc-2.34"
# MPFR="${BUILD_DIR}/mpfr-4.1.0"
# GMP="BUILD_DIR}/gmp-6.2.0"
# MPC="$BUILD_DIR}/mpc-1.2.1"
# ISL="${BUILD_DIR}/isl-0.24"
# CLOOG="${BUILD_DIR}/cloog-0.18.1"
#ARCH="x86_x64"
#TARGET="amd64-linux"
#HOST="amd64-linux"
ARCH="arm64"
TARGET="aarch64-linux"
HOST="aarch64-linux"
# WMUSL=""
# × × × × × × × × × × × × × × × #
### × SYMLINKS × ###
# Create symbolic links from the GCC directory to some of the other directories. 
# These five packages are dependencies of GCC, and when the symbolic links are present, 
# GCC’s build script will [build them automatically](https://gcc.gnu.org/install/download.html).
debug "Changing directory to $GCC"
cd "$GCC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Creating symbolic links"
debug "MPFR"
ln -s ../mpfr-4.1.0 mpfr
# ln -s "$MPFR" mpfr
debug "GMP"
ln -s ../gmp-6.2.0 gmp
# ln -s "$GMP" gmp
debug "MPC"
ln -s ../mpc-1.2.1 mpc
# ln -s "$MPC" mpc
debug "ISL"
ln -s ../isl-0.24 isl
# ln -s "$ISL" isl
debug "CLOOG"
ln -s ../cloog-0.18.1 cloog
# ln -s "$CLOOG" cloog
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
<<COMMENT
Choose an installation directory, and make sure you have write permission to it. 
In the steps that follow, I’ll install the new toolchain to /opt/cross.
Throughout the entire build process, make sure the installation’s bin subdirectory is in your PATH environment variable. 
You can remove this directory from your PATH later, but most of the build steps expect to find aarch64-linux-gcc and other host tools via the PATH by default.

Pay particular attention to the stuff that gets installed under /opt/cross/aarch64-linux/. 
This directory is considered the system root of an imaginary AArch64 Linux target system. 
A self-hosted AArch64 Linux compiler could, in theory, use all the headers and libraries placed here. 
Obviously, none of the programs built for the host system, such as the cross-compiler itself, will be installed to this directory.
COMMENT
# × × × × × × × × × × × × × × × × × × # 
debug "Exporting /opt/cross/bin to PATH"
export PATH="/opt/cross/bin:$PATH"
# × × × × × × × × × × × × × × × × × × # 
<<COMMENT
Build linux kernel headers
This step installs the Linux kernel header files to /opt/cross/aarch64-linux/include, 
which will ultimately allow programs built using our new toolchain to make 
system calls to the AArch64 kernel in the target environment.
COMMENT
# × × × × × × × × × × × × × × × × × × # 
debug "Changing working directory to $KERNEL"
cd "$KERNEL" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Linux kernel headers"
make ARCH="$ARCH" INSTALL_HDR_PATH="${CROSS_DIR}/${TARGET}" headers_install
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing working directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
<<COMMENT
Build Binutils
This step builds and installs the cross-assembler, cross-linker, and other tools.
Weve specified aarch64-linux as the target system type. 
Binutils configure script will recognize that this target is different from the machine were building on, 
and configure a cross-assembler and cross-linker as a result. The tools will be installed to /opt/cross/bin, their names prefixed by aarch64-linux-.
--disable-multilib means that we only want our Binutils installation to work with programs and libraries using the AArch64 instruction set, 
and not any related instruction sets such as AArch32.
COMMENT
# × × × × × × × × × × × × × × × × × × # 
debug "Changing working directory to $BUILD_BINUTILS"
cd "$BUILD_BINUTILS" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Binutils"
"$BINUTILS"/configure --prefix="$CROSS_DIR" --target="$TARGET" --disable-multilib
make -j4
make install
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing working directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
# Build GCC's C & C++ cross-compilers to /opt/cross/bin
debug "Build GCC's C & C++ cross-compilers to /opt/cross/bin"
"${GCC}"/configure --prefix="${CROSS_DIR}" --target="${TARGET}" --enable-languages=c,c++ --disable-multilib
make -j4 all-gcc
make install-gcc
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_GLIBC"
cd "$BUILD_GLIBC" || exit 1
# cd "$BUILD_MUSL"
# × × × × × × × × × × × × × × × × × × # 
# Install glibc's standard C library headers to /opt/cross/amd64-linux/include
debug "Install glibc's standard C library to /opt/cross/${HOST}"
"${GLIBC}"/configure --prefix="${CROSS_DIR}/${TARGET}" --build="${MACHTYPE}" --host="${HOST}" --target="${TARGET}" --with-headers="${CROSS_DIR}/${TARGET}/include" --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "${CROSS_DIR}/${TARGET}/lib"
"${TARGET}"-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "${CROSS_DIR}/${TARGET}/lib/libc.so"
touch "${CROSS_DIR}/${TARGET}/include/gnu/stubs.h"
debug "Install glibc's standard C library to /opt/cross/${TARGET}"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# Compiler support library
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Install compiler support library"
make -j4 all-target-libgcc
make install-target-libgcc
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
# × × × × × × × × × × × × × × × × × × #
# Standard C library
debug "GCC Standard C library"
make -j4
make install
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Completed"

exit 0
