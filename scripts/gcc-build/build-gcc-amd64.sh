#!/usr/bin/env bash
#
# shellcheck disable=SC1073
# shellcheck disable=SC2188
# 
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl
# 
# Builds a cross-compiler for AMD 64bit CPU instructionset
#
# I followed this article/blog post and modified it 
# https://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/
#
# Signature for the kernel
# https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.sign
# 
# × × × × × × × × × × × × × × × × × × # 
debug() {
    PFX="INFO"
    printf '%s\n' "${PFX} ${*}"
}
# × × × × × × × × × × × × × × × × × × # 
debug "Starting build script for GCC Cross-Compiler"
# × × × VARIABLES × × × #
ARCH="x86_x64"
TARGET="amd64-linux"
HOST="amd64-linux"
BINUTILSv="binutils-2.37"
GCCv="gcc-10.3.0"
KERNELv="linux-5.15.12"
GLIBCv="glibc-2.34"
MPFRv="mpfr-4.1.0"
GMPv="gmp-6.2.0"
MPCv="mpc-1.2.1"
ISLv="isl-0.24"
CLOOGv="cloog-0.18.1"
# × × × DIRECTORIES × × × #
CURRENT_DIR="$(pwd)"
CROSS_DIR="${CURRENT_DIR}/cross"
BUILD_DIR="${CURRENT_DIR}/build"
BUILD_BINUTILS="${BUILD_DIR}/build-binutils"
BUILD_GCC="${BUILD_DIR}/build-gcc"
BUILD_GLIBC="${BUILD_DIR}/build-glibc"
# × × × × × × × × × × × × × × × × × × #
BINUTILS="${BUILD_DIR}/${BINUTILSv}"
GCC="${BUILD_DIR}/${GCCv}"
KERNEL="${BUILD_DIR}/${KERNELv}"
GLIBC="${BUILD_DIR}/${GLIBCv}"
# × × × × × × × × × × × × × × × × × × # 
debug "Creating directories: $BUILD_DIR $BUILD_GLIBC $BUILD_GCC $BUILD_BINUTILS $CROSS_DIR"
mkdir -p "$BUILD_DIR" "$CROSS_DIR" "$BUILD_BINUTILS" "$BUILD_GCC" "$BUILD_GLIBC"
debug "Done" 
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Download: Binutils GCC Kernel Glibc MPFR GMP MPC ISL CLOOG"
wget "https://mirrors.kernel.org/gnu/binutils/${BINUTILSv}.tar.xz"
wget "https://mirrors.kernel.org/gnu/gcc/${GCCv}/${GCCv}.tar.xz"
wget "https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/${KERNELv}.tar.xz"
wget "https://mirrors.kernel.org/gnu/glibc/${GLIBCv}.tar.xz"
wget "https://mirrors.kernel.org/gnu/mpfr/${MPFRv}.tar.xz"
wget "https://gmplib.org/download/gmp/${GMPv}.tar.xz"
wget "http://mirror.us-midwest-1.nexcess.net/gnu/mpc/${MPCv}.tar.gz"
wget "https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/${ISLv}.tar.bz2"
wget "https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/${CLOOGv}.tar.gz"
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
# × × × Build Steps × × × #
debug "Extracting source packages from tar"
for f in *.tar*; do tar xf "$f"; done
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Removing source packages tar archive"
for f in *.tar*; do rm "$f"; done
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
# × × × SYMLINKS × × × #
# Create symbolic links from the GCC directory to some of the other directories. 
# These five packages are dependencies of GCC, and when the symbolic links are present, 
# GCC’s build script will build them automatically.
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $GCC"
cd "$GCC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Creating symbolic links"
debug "MPFR"
ln -s ../"$MPFRv" mpfr
debug "GMP"
ln -s ../"$GMPv" gmp
debug "MPC"
ln -s ../"$MPCv" mpc
debug "ISL"
ln -s ../"$ISLv" isl
debug "CLOOG"
ln -s ../"$CLOOGv" cloog
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
# Choose an installation directory, and make sure you have write permission to it. 
# Throughout the entire build process, make sure the installation’s bin subdirectory is in your PATH environment variable. 
# You can remove this directory from your PATH later, but most of the build steps expect to find aarch64-linux-gcc and other host tools via the PATH by default.
debug "Exporting ${CROSS_DIR}/bin to PATH"
export PATH="${CROSS_DIR}/bin:$PATH"
# × × × × × × × × × × × × × × × × × × # 
# Pay particular attention to the stuff that gets installed under ${CROSS_DIR}/${TARGET}. 
# This directory is considered the system root of an imaginary AArch64 Linux target system. 
# A self-hosted aarch64 or amd64 Linux compiler could, in theory, use all the headers and libraries placed here. 
# Obviously, none of the programs built for the host system, such as the cross-compiler itself, will be installed to this directory.
# × × × × × × × × × × × × × × × × × × # 
# Build linux kernel headers
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
# Build Binutils
debug "Changing working directory to $BUILD_BINUTILS"
cd "$BUILD_BINUTILS" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Binutils"
"${BINUTILS}"/configure --prefix="$CROSS_DIR" --target="$TARGET" --disable-multilib
make -j4
make install
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing working directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
# Build GCC's C & C++ cross-compilers to ${CROSS_DIR}/bin
debug "Changing directory to $BUILD_GCC"
cd "${BUILD_GCC}" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Build GCC's C & C++ cross-compilers to ${CROSS_DIR}/${TARGET}"
"$GCC"/configure --prefix="$CROSS_DIR" --target="$TARGET" --enable-languages=c,c++ --disable-multilib
make -j4 all-gcc
make install-gcc
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
# Install glibc's standard C library headers
debug "Changing directory to $BUILD_GLIBC"
cd "$BUILD_GLIBC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Install glibc's standard C library to ${CROSS_DIR}/${TARGET}"
"$GLIBC"/configure --prefix="${CROSS_DIR}/${TARGET}" --build="$MACHTYPE" --host="$HOST" --target="$TARGET" --with-headers="${CROSS_DIR}/${TARGET}/include" --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "${CROSS_DIR}/${TARGET}/lib"
amd64-linux-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "${CROSS_DIR}/${TARGET}/lib/libc.so"
touch "${CROSS_DIR}/${TARGET}/include/gnu/stubs.h"
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
# Compiler support library
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
# Standard C library
debug "Changing directory to $BUILD_GCC"
cd "$BUILD_GCC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Install GCC Standard C library"
make -j $(nproc)
make install
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Changing directory to $CURRENT_DIR"
cd "$CURRENT_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "GCC Build has completed"
# × × × × × × × × × × × × × × × × × × # 
exit 0
