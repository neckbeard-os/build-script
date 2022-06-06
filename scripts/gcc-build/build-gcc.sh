#!/usr/bin/env bash
# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 
# https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.sign

colour() {
	# @ZendaiOwl
	if [ $# -lt 1 ]; then
		colour="$1"
		reset="$(tput sgr0)"
		printf '%s' "$colour$1$reset"
	elif [ $# -eq 2 ] && [ "${1}" -gt 0 ] && [ "$1" -lt 256 ]; then
			reset="$(tput sgr0)"
			c1="$(tput setaf "${1}")"
				printf '%s' "$c1$2$reset"
				printf '\n';
	elif [ $# -eq 4 ] && 
			[ "${1}" -gt 0 ] && [ "${1}" -lt 256 ] &&
			[ "${3}" -gt 0 ] && [ "${3}" -lt 256 ]; then
			reset="$(tput sgr0)"
			c1="$(tput setaf "${1}")"
			c2="$(tput setaf "${3}")"
				printf '%s ' "$c1$2$c2$4$reset"
				printf '\n';
	elif [ $# -eq 6 ] &&
			[ "${1}" -gt 0 ] && [ "${1}" -lt 256 ] && 
			[ "${3}" -gt 0 ] && [ "${3}" -lt 256 ] && 
			[ "${5}" -gt 0 ] && [ "${5}" -lt 256 ]; then
			reset="$(tput sgr0)"
			c1="$(tput setaf "${1}")"
			c2="$(tput setaf "${3}")"
			c3="$(tput setaf "${5}")"
				printf '%s ' "$c1$2$c2$4$c3$6$reset"
				printf '\n';
	elif [ $# -eq 8 ] &&
			[ "${1}" -gt 0 ] && [ "${1}" -lt 256 ] && 
			[ "${3}" -gt 0 ] && [ "${3}" -lt 256 ] && 
			[ "${5}" -gt 0 ] && [ "${5}" -lt 256 ] &&
			[ "${7}" -gt 0 ] && [ "${7}" -lt 256 ]; then
			reset="$(tput sgr0)"
			c1="$(tput setaf "${1}")"
			c2="$(tput setaf "${3}")"
			c3="$(tput setaf "${5}")"
			c4="$(tput setaf "${7}")"
				printf '%s' "$c1$2$c2$4$c3$6$c4$8$reset"
				printf '\n';
	else
	echo "Usage: [Colour nr1] [String 1] [Colour nr2] [String 2] [Colour nr3] [String 3] [Colour nr4] [String 4]"
	echo "Maximum is 8, 4 colours and 4 strings"
	echo "Allowed colour numbers are within the range of 1 to 255"
	fi
	
}

colour 46 "GCC-Build" 15 ": Starting build script"

BUILD_DIR=/docker/build
CROSS_DIR=/opt/cross
BUILD_BINUTILS="${BUILD_DIR}/build-binutils"
BUILD_GCC="${BUILD_DIR}/gcc-build"
BUILD_GLIBC="$BUILD_DIR/build-glibc"

colour 46 "GCC-Build" 15 ": Creating directories"

mkdir -p "${BUILD_DIR}"
colour 46 "GCC-Build" 226 " $BUILD_DIR " 48 "Complete"
mkdir -p "${CROSS_DIR}"
colour 46 "GCC-Build" 226 " $CROSS_DIR " 48 "Complete"
mkdir -p "${BUILD_BINUTILS}"
colour 46 "GCC-Build" 226 " $BUILD_BINUTILS " 48 "Complete"
mkdir -p "${BUILD_GCC}"
colour 46 "GCC-Build" 226 " $BUILD_GCC " 48 "Complete"
mkdir -p "$BUILD_GLIBC"
colour 46 "GCC-Build" 226 " $BUILD_GLIBC " 48 "Complete"

colour 46 "GCC-Build" 15 ": Creating directories " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "${BUILD_DIR}" || exit 1
colour 46 "GCC-Build" 15 ": Downloading " 226 "binutils gcc kernel glibc mpfr gmp mpc isl cloog"
wget https://mirrors.kernel.org/gnu/binutils/binutils-2.37.tar.xz
wget https://mirrors.kernel.org/gnu/gcc/gcc-10.3.0/gcc-10.3.0.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.12.tar.xz
wget https://mirrors.kernel.org/gnu/glibc/glibc-2.34.tar.xz
wget https://mirrors.kernel.org/gnu/mpfr/mpfr-4.1.0.tar.xz
wget https://mirrors.tripadvisor.com/gnu/gmp/gmp-6.2.0.tar.bz2
wget http://mirror.us-midwest-1.nexcess.net/gnu/mpc/mpc-1.2.1.tar.gz
wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2
wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
colour 46 "GCC-Build" 15 ": Download " 48 "Complete"

# [ Build Steps ]
colour 46 "GCC-Build" 15 ": Starting build"
# Extract all the source packages.
colour 46 "GCC-Build" 15 ": Extracting source packages.."
for f in *.tar*; do tar xf "$f"; done
colour 46 "GCC-Build" 15 ": Extracting source packages " 48 "Complete"
colour 46 "GCC-Build" 15 ": Removing source packages.."
for f in *.tar*; do rm "$f"; done
colour 46 "GCC-Build" 15 ": Removing source packages " 48 "Complete"

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

# Create symbolic links from the GCC directory to some of the other directories. 
# These five packages are dependencies of GCC, and when the symbolic links are present, 
# GCC’s build script will build them automatically.
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$GCC" || exit 1
colour 46 "GCC-Build" 15 ": Creating symbolic links"
colour 46 "GCC-Build" 15 ": Creating link " 226 "mpfr"
ln -s ../mpfr-4.1.0 mpfr
colour 46 "GCC-Build" 15 ": Creating link " 226 "gmp"
ln -s ../gmp-6.2.0 gmp
colour 46 "GCC-Build" 15 ": Creating link " 226 "mpc"
ln -s ../mpc-1.2.1 mpc
colour 46 "GCC-Build" 15 ": Creating link " 226 "isl"
ln -s ../isl-0.24 isl
colour 46 "GCC-Build" 15 ": Creating link " 226 "cloog"
ln -s ../cloog-0.18.1 cloog
colour 46 "GCC-Build" 15 ": Creating symbolic links " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Choose an installation directory, and make sure you have write permission to it. 
# In the steps that follow, I’ll install the new toolchain to /opt/cross.
# Throughout the entire build process, make sure the installation’s bin subdirectory is in your PATH environment variable. 
# You can remove this directory from your PATH later, but most of the build steps expect to find aarch64-linux-gcc and other host tools via the PATH by default.
colour 46 "GCC-Build" 15 ": Exporting /opt/cross/bin to PATH"
export PATH=/opt/cross/bin:$PATH
colour 46 "GCC-Build" 15 ": Exporting /opt/cross/bin to PATH " 48 "Complete"

# Pay particular attention to the stuff that gets installed under /opt/cross/aarch64-linux/. 
# This directory is considered the system root of an imaginary AArch64 Linux target system. 
# A self-hosted AArch64 Linux compiler could, in theory, use all the headers and libraries placed here. 
# Obviously, none of the programs built for the host system, such as the cross-compiler itself, will be installed to this directory.

# Build/install linux kernel headers
colour 46 "GCC-Build" 15 ": Build/install linux kernel headers"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$KERNEL"
cd "$KERNEL" || exit 1
make ARCH="$ARCH" INSTALL_HDR_PATH="$CROSS_DIR/$TARGET" headers_install
colour 46 "GCC-Build" 15 ": Build/install linux kernel headers" 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Build/install binutils
colour 46 "GCC-Build" 15 ": Build/install binutils"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_BINUTILS" || exit 1
"$BINUTILS"/configure --prefix="$CROSS_DIR" --target="$TARGET" --disable-multilib
make -j4
make install
colour 46 "GCC-Build" 15 ": Build/install binutils " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Build GCC's C & C++ cross-compilers to /opt/cross/bin
colour 46 "GCC-Build" 15 ": Build GCC's C & C++ cross-compilers to /opt/cross/bin"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_GCC"
cd "$BUILD_GCC" || exit 1
"$GCC"/configure --prefix="$CROSS_DIR" --target="$TARGET" --enable-languages=c,c++ --disable-multilib
make -j4 all-gcc
make install-gcc
colour 46 "GCC-Build" 15 ": Build GCC's C & C++ cross-compilers to /opt/cross/bin " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Install glibc's standard C library headers to /opt/cross/amd64-linux/include
colour 46 "GCC-Build" 15 ": Install glibc's standard C library to /opt/cross/amd64-linux"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_GLIBC"
cd "$BUILD_GLIBC" || exit 1
# cd "$BUILD_MUSL"
"$GLIBC"/configure --prefix="$CROSS_DIR/$TARGET" --build="$MACHTYPE" --host="$HOST" --target="$TARGET" --with-headers="$CROSS_DIR/$TARGET/include" --disable-multilib libc_cv_forced_unwind=yes
make install-bootstrap-headers=yes install-headers
make -j4 csu/subdir_lib
install csu/crt1.o csu/crti.o csu/crtn.o "$CROSS_DIR/$TARGET/lib"
amd64-linux-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o "$CROSS_DIR/$TARGET/lib/libc.so"
touch "$CROSS_DIR/$TARGET/include/gnu/stubs.h"
colour 46 "GCC-Build" 15 ": Install glibc's standard C library to /opt/cross/amd64-linux " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Compiler support library
colour 46 "GCC-Build" 15 ": Install compiler support library"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_GCC"
cd "$BUILD_GCC" || exit 1
make -j4 all-target-libgcc
make install-target-libgcc
colour 46 "GCC-Build" 15 ": Install compiler support library " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

# Standard C library
colour 46 "GCC-Build" 15 ": Install GCC Standard C library"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_GCC"
cd "$BUILD_GCC" || exit 1
make -j4
make install
colour 46 "GCC-Build" 15 ": Install GCC Standard C library " 48 "Complete"
colour 46 "GCC-Build" 15 ": Changing directory to " 226 "$BUILD_DIR"
cd "$BUILD_DIR" || exit 1

colour 46 "GCC-Build" 15 ": Build " 48 "Complete!"

exit
