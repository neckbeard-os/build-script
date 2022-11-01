# × × × × × × × × × × × × × × × × × × #
# The available target architectures
# The currently set one is x84_64-linux-musl, use sed -i and change it in config.mak before copying it
# TARGET = i486-linux-musl
# TARGET = x86_64-linux-musl
# TARGET = arm-linux-musleabi
# TARGET = arm-linux-musleabihf
# TARGET = sh2eb-linux-muslfdpic
# TARGET = riscv64-linux-musl
# Ex.
# TARGET = riscv64-linux-musl
# × × × × × × × × × × × × × × × × × × #
# By default, cross compilers are installed to ./output under the top-level
# musl-cross-make directory and can later be moved wherever you want them.
# To install directly to a specific location, set it here. Multiple targets
# can safely be installed in the same location. Some examples:
# OUTPUT = /opt/cross
# OUTPUT = /usr/local
# × × × × × × × × × × × × × × × × × × #
# By default, latest supported release versions of musl and the toolchain
# components are used. You can override those here, but the version selected
# must be supported (under hashes/ and patches/) to work. For musl, you
# can use "git-refname" (e.g. git-master) instead of a release. Setting a
# blank version for gmp, mpc, mpfr and isl will suppress download and
# in-tree build of these libraries and instead depend on pre-installed
# libraries when available (isl is optional and not set by default).
# Setting a blank version for linux will suppress installation of kernel
# headers, which are not needed unless compiling programs that use them.
# BINUTILS_VER = 2.25.1
# GCC_VER = 5.2.0
# MUSL_VER = git-master
# GMP_VER =
# MPC_VER =
# MPFR_VER =
# ISL_VER =
# LINUX_VER =
# × × × × × × × × × × × × × × × × × × #
# By default source archives are downloaded with wget. curl is also an option.
# DL_CMD = wget -c -O
# DL_CMD = curl -C - -L -o
# × × × × × × × × × × × × × × × × × × #
# Check sha-1 hashes of downloaded source archives. On gnu systems this is
# usually done with sha1sum.
# SHA1_CMD = sha1sum -c
# SHA1_CMD = sha1 -c
# SHA1_CMD = shasum -a 1 -c
# × × × × × × × × × × × × × × × × × × #
# Something like the following can be used to produce a static-linked
# toolchain that's deployable to any system with matching arch, using
# an existing musl-targeted cross compiler. This only works if the
# system you build on can natively (or via binfmt_misc and qemu) run
# binaries produced by the existing toolchain (in this example, i486).
# COMMON_CONFIG += CC="i486-linux-musl-gcc -static --static" CXX="i486-linux-musl-g++ -static --static"
# × × × × × × × × × × × × × × × × × × #
# Recommended options for smaller build for deploying binaries:
# COMMON_CONFIG += CFLAGS="-g0 -Os" CXXFLAGS="-g0 -Os" LDFLAGS="-s"
# × × × × × × × × × × × × × × × × × × #
# Options you can add for faster/simpler build at the expense of features:
# COMMON_CONFIG += --disable-nls
# GCC_CONFIG += --disable-libquadmath --disable-decimal-float
# GCC_CONFIG += --disable-libitm
# GCC_CONFIG += --disable-fixed-point
# GCC_CONFIG += --disable-lto
# × × × × × × × × × × × × × × × × × × #
# By default C and C++ are the only languages enabled, and these are
# the only ones tested and known to be supported. You can uncomment the
# following and add other languages if you want to try getting them to
# work too.
# GCC_CONFIG += --enable-languages=c,c++
# × × × × × × × × × × × × × × × × × × #
# You can keep the local build path out of your toolchain binaries and
# target libraries with the following, but then gdb needs to be told
# where to look for source files.
# COMMON_CONFIG += --with-debug-prefix-map=$(CURDIR)=
# × × × × × × × × × × × × × × × × × × #
#TARGET = riscv64-linux-musl
#OUTPUT = /workspaces/build-script/RISC-V/output
# × × × × × × × × × × × × × × × × × × #

STAT = -static --static
FLAG = -g0 -O2 -fno-align-functions -fno-align-jumps -fno-align-loops -fno-align-labels -Wno-error

ifneq ($(NATIVE),)
COMMON_CONFIG += CC="$(HOST)-gcc ${STAT}" CXX="$(HOST)-g++ ${STAT}" FC="$(HOST)-gfortran ${STAT}"
else
COMMON_CONFIG += CC="gcc ${STAT}" CXX="g++ ${STAT}" FC="gfortran ${STAT}"
endif

COMMON_CONFIG += CFLAGS="${FLAG}" CXXFLAGS="${FLAG}" FFLAGS="${FLAG}" LDFLAGS="-s ${STAT}"

BINUTILS_CONFIG += --enable-gold=yes
GCC_CONFIG += --enable-default-pie --enable-static-pie --disable-cet

# The recommended configurations which unfortunately doesn't work
# CONFIG_SUB_REV = 888c8e3d5f7b
# GCC_VER = 10.3.0
# BINUTILS_VER = 2.37
# MUSL_VER = git-b76f37fd5625d038141b52184956fb4b7838e9a5
# GMP_VER = 6.2.1
# MPC_VER = 1.2.1
# MPFR_VER = 4.1.0
# LINUX_VER = 5.15.2

# My configurations that work, at least at the moment
BINUTILS_VER = 2.33.1
GCC_VER = 10.3.0
MUSL_VER = git-master
GMP_VER = 6.1.2
MPC_VER = 1.1.0
MPFR_VER = 4.0.2
ISL_VER = 0.15
LINUX_VER = 5.8.5
