#!/bin/sh

download_utilities () {
  cd "$DOWNLOADS_DIR" || exit

  github_fetch "landley/toybox"
}

compile_utilities () {
  download_utilities

  cd "$DOWNLOADS_DIR/toybox" || exit

  make clean
  make defconfig

  export CFLAGS="-target $ARCH-pc-linux-musl --sysroot $DOWNLOADS_DIR/$ARCH-linux-musl-cross"
  export LDFLAGS="-static"
  export CC=clang

  make toybox
}

# x86_64-linux-musl

# Build static with musl-cross-make gcc toolchain

# LDFLAGS="--static"
# CROSS_COMPILE=$DOWNLOADS_DIR/$ARCH-linux-musl-cross/bin/$ARCH-linux-musl-
# make toybox


# Build static with clang using musl-cross-make as sysroot

# CFLAGS="-target $ARCH-pc-linux-musl --sysroot $DOWNLOADS_DIR/$ARCH-linux-musl-cross"
# LDFLAGS="-static"
# CC=clang
# make toybox


# https://github.com/rethink-neil/musl-cross-make-toybox/blob/master/build

# export CROSS_COMPILE="$ARCH-linux-musl-"
# export PATH="$DOWNLOADS_DIR"/toolchain/output/bin:"$PATH"
# export CFLAGS="--static"
# export LDFLAGS="--static"

# make defconfig
# make -j"$CORES" all