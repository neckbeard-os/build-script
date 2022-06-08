#!/usr/bin/env bash
# shellcheck disable=SC1073
# shellcheck disable=SC2188 
<<COMMENT
# @Victor-ray, S. <victorray91@pm.me> 
# (https://github.com/ZendaiOwl)

# Builds a cross-compiler for AMD64bit instructionset 
# I followed this article/blog post and modified it 
# https://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/

# https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.sign - signature for the kernel
COMMENT
#×× DEBUG
debug() {
	GREENISH="$(tput setaf 46)"
	RESET="$(tput sgr0)"
    PFX="${GREENISH}GCC BUILD INFO${RESET} ${*}"
    printf '%s\n' "${PFX}"
}

debug "Starting build script for GCC Cross-Compiler"
### × DIRECTORIES × ###
BUILD_DIR="/docker/build"
CROSS_DIR="/opt/cross"
BUILD_BINUTILS="${BUILD_DIR}/build-binutils"
BUILD_GCC="${BUILD_DIR}/gcc-build"
BUILD_GLIBC="$BUILD_DIR/build-glibc"
# × × × × × × × × × × × × × × × × × × # 
debug "Creating directories" "${BUILD_DIR}" "${BUILD_GLIBC}" "${BUILD_GCC}" "${BUILD_BINUTILS}" "${CROSS_DIR}"
mkdir -p "${BUILD_DIR}" "${CROSS_DIR}" "${BUILD_BINUTILS}" "${BUILD_GCC}" "${BUILD_GLIBC}"

debug "Created directories" "Changing directory to ${BUILD_DIR}"
cd "${BUILD_DIR}" || exit 1
debug "Downloading: Binutils GCC Kernel Glibc MPFR GMP MPC ISL CLOOG"
wget https://mirrors.kernel.org/gnu/binutils/binutils-2.37.tar.xz
wget https://mirrors.kernel.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.xz
wget https://mirrors.kernel.org/gnu/glibc/glibc-2.34.tar.xz
wget https://mirrors.kernel.org/gnu/mpfr/mpfr-4.1.0.tar.xz
# wget https://mirrors.tripadvisor.com/gnu/gmp/gmp-6.2.0.tar.bz2
wget https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz
wget http://mirror.us-midwest-1.nexcess.net/gnu/mpc/mpc-1.2.1.tar.gz
wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2
wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
debug "Download completed"

### × [ Build Steps ] × ###
# Extract all the source packages.
debug "Extracting source packages.."
for f in *.tar*; do tar xf "${f}"; done
debug "Extracted" "Removing source packages.."
for f in *.tar*; do rm "${f}"; done
debug "Removed"
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
ARCH="x86_x64"
TARGET="amd64-linux"
# WMUSL=""
HOST="amd64-linux"
# × × × × × × × × × × × × × × × #
### × SYMLINKS × ###
# Create symbolic links from the GCC directory to some of the other directories. 
# These five packages are dependencies of GCC, and when the symbolic links are present, 
# GCC’s build script will build them automatically.
debug "Changing directory to $BUILD_DIR"
cd "$GCC" || exit 1
debug "Creating symbolic links" "Symlink: mpfr"
ln -s ../mpfr-4.1.0 mpfr
debug "Symlink: gmp"
ln -s ../gmp-6.2.0 gmp
debug "Symlink: mpc"
ln -s ../mpc-1.2.1 mpc
debug "Symlink: isl"
ln -s ../isl-0.24 isl
debug "Symlink: cloog"
ln -s ../cloog-0.18.1 cloog
debug "Symlinks created" "Changing directory to $BUILD_DIR"
cd "${BUILD_DIR}" || exit 1

# Choose an installation directory, and make sure you have write permission to it. 
# In the steps that follow, I’ll install the new toolchain to /opt/cross.
# Throughout the entire build process, make sure the installation’s bin subdirectory is in your PATH environment variable. 
# You can remove this directory from your PATH later, but most of the build steps expect to find aarch64-linux-gcc and other host tools via the PATH by default.
debug "Exporting /opt/cross/bin to PATH"
export PATH="/opt/cross/bin:$PATH"

# Pay particular attention to the stuff that gets installed under /opt/cross/aarch64-linux/. 
# This directory is considered the system root of an imaginary AArch64 Linux target system. 
# A self-hosted AArch64 Linux compiler could, in theory, use all the headers and libraries placed here. 
# Obviously, none of the programs built for the host system, such as the cross-compiler itself, will be installed to this directory.

# Build linux kernel headers
debug "Build: Linux Kernel Headers" "Changing working directory to ${KERNEL}"
cd "${KERNEL}" || exit 1
make ARCH="$ARCH" INSTALL_HDR_PATH="${CROSS_DIR}/${TARGET}" headers_install
debug "Linux Kernel Headers - Done" "Changing working directory to $BUILD_DIR"
cd "${BUILD_DIR}" || exit 1

# Build Binutils
debug "Build: Binutils" "Changing working directory to $BUILD_DIR"
cd "${BUILD_BINUTILS}" || exit 1
"${BINUTILS}"/configure --prefix="${CROSS_DIR}" --target="${TARGET}" --disable-multilib
make -j4
make install
debug "Binutils - Done"
debug "Changing working directory to $BUILD_DIR"
cd "${BUILD_DIR}" || exit 1

# Build GCC's C & C++ cross-compilers to /opt/cross/bin
debug "Build GCC's C & C++ cross-compilers to /opt/cross/bin" "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
"${GCC}"/configure --prefix="${CROSS_DIR}" --target="${TARGET}" --enable-languages=c,c++ --disable-multilib
make -j4 all-gcc
make install-gcc
debug "Build GCC's C & C++ cross-compilers to /opt/cross/bin" "Changing directory to $BUILD_DIR"
cd "${BUILD_DIR}" || exit 1

# Install glibc's standard C library headers to /opt/cross/amd64-linux/include
debug "Install glibc's standard C library to /opt/cross/${HOST}" "Changing directory to $BUILD_GLIBC"
cd "${BUILD_GLIBC}" || exit 1
# cd "$BUILD_MUSL"
"${GLIBC}"/configure --prefix="${CROSS_DIR}/${TARGET}" --build="${MACHTYPE}" --host="${HOST}" --target="${TARGET}" --with-headers="${CROSS_DIR}/${TARGET}/include" --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "$CROSS_DIR/$TARGET/lib"
amd64-linux-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "${CROSS_DIR}/${TARGET}/lib/libc.so"
touch "${CROSS_DIR}/${TARGET}/include/gnu/stubs.h"
debug "Install glibc's standard C library to /opt/cross/amd64-linux" "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Compiler support library
debug "Install compiler support library" "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
make -j4 all-target-libgcc
make install-target-libgcc
debug "Install compiler support library" "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Standard C library
debug "Install GCC Standard C library" "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
make -j4
make install
debug "Install GCC Standard C library" "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
debug "Build GCC - Done"

exit 0
