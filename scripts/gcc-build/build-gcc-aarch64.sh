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
    PFX="INFO"
    printf '%s\n' "${PFX} ${*}"
}
set -euo pipefail
debug "Starting build script for GCC Cross-Compiler"
# × × × × × × × × × × × × × × × × × × # 
# × × × VARIABLES × × × #
BINUTILSv="binutils-2.37"
GCCv="gcc-10.3.0"
KERNELv="linux-5.15.12"
GLIBCv="glibc-2.34"
MPFRv="mpfr-4.1.0"
GMPv="gmp-6.2.0"
MPCv="mpc-1.2.1"
ISLv="isl-0.24"
CLOOGv="cloog-0.18.1"
#ARCH="x86_x64"
#TARGET="amd64-linux"
#HOST="amd64-linux"
ARCH="arm64"
TARGET="aarch64-linux"
HOST="aarch64-linux"
# × × × DIRECTORIES × × × #
CURRENT_DIR="$(pwd)"
BUILD_DIR="${CURRENT_DIR}/build"
CROSS_DIR="${CURRENT_DIR}/cross"
BUILD_BINUTILS="${BUILD_DIR}/build-binutils"
BUILD_GCC="${BUILD_DIR}/build-gcc"
BUILD_GLIBC="${BUILD_DIR}/build-glibc"
# × × × × × × × × × × × × × × × × × × #
BINUTILS="${BUILD_DIR}/${BINUTILSv}"
GCC="${BUILD_DIR}/${GCCv}"
KERNEL="${BUILD_DIR}/${KERNELv}"
GLIBC="${BUILD_DIR}/${GLIBCv}"
# × × × × × × × × × × × × × × × × × × # 
debug "Creating directories: $BUILD_DIR $CROSS_DIR $BUILD_BINUTILS $BUILD_GCC $BUILD_GLIBC"
mkdir -p "$BUILD_DIR" "$CROSS_DIR" "$BUILD_BINUTILS" "$BUILD_GCC" "$BUILD_GLIBC"
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Download: BINUTILS GCC KERNEL GLIBC MPFR GMP MPC ISL CLOOG"
wget "https://mirrors.kernel.org/gnu/binutils/${BINUTILSv}.tar.xz" || exit 1
wget "https://mirrors.kernel.org/gnu/gcc/${GCCv}/${GCCv}.tar.xz" || exit 1
wget "https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/${KERNELv}.tar.xz" || exit 1
wget "https://mirrors.kernel.org/gnu/glibc/${GLIBCv}.tar.xz" || exit 1
wget "https://mirrors.kernel.org/gnu/mpfr/${MPFRv}.tar.xz" || exit 1
wget "https://gmplib.org/download/gmp/${GMPv}.tar.xz" || exit 1
wget "http://mirror.us-midwest-1.nexcess.net/gnu/mpc/${MPCv}.tar.gz" || exit 1
wget "https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/${ISLv}.tar.bz2" || exit 1
wget "https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/${CLOOGv}.tar.gz" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
# × × × Build × × × #
debug "Extract source packages from tar archive"
for f in *.tar*; do tar xf "$f"; done
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Remove source packages tar archive"
for f in *.tar*; do rm "$f"; done
debug "Done"
# × × × × × × × × × × × × × × × #
# × × × SYMLINKS × × × #
# Create symbolic links from the GCC directory to some of the other directories. 
# These five packages are dependencies of GCC, and when the symbolic links are present, 
# GCC’s build script will [build them automatically](https://gcc.gnu.org/install/download.html).
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
debug "Exporting ${CROSS_DIR}/bin to PATH"
export PATH="${CROSS_DIR}/bin:$PATH"
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
debug "Build GCC's C & C++ cross-compilers to $CROSS_DIR"
"$GCC"/configure --prefix="$CROSS_DIR" --target="$TARGET" --enable-languages=c,c++ --disable-multilib
make -j4 all-gcc
make install-gcc
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_GLIBC"
cd "$BUILD_GLIBC" || exit 1
# × × × × × × × × × × × × × × × × × × # 
debug "Install glibc's standard C library to ${CROSS_DIR}/${TARGET}"
"$GLIBC"/configure --prefix="${CROSS_DIR}/${TARGET}" --build="$MACHTYPE" --host="$HOST" --target="$TARGET" --with-headers="${CROSS_DIR}/${TARGET}/include" --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "${CROSS_DIR}/${TARGET}/lib"
"$TARGET"-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "${CROSS_DIR}/${TARGET}/lib/libc.so"
touch "${CROSS_DIR}/${TARGET}/include/gnu/stubs.h"
debug "Done"
# × × × × × × × × × × × × × × × × × × # 
debug "Changing directory to $BUILD_DIR"
cd "$BUILD_DIR" || exit 1
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
debug "Changing directory to $CURRENT_DIR"
cd "$CURRENT_DIR" || exit 1
debug "Done"
# × × × × × × × × × × × × × × × × × × #
debug "Completed"

exit 0
