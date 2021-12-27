#!/bin/sh

# Distro
export DISTRO_NAME="Neckbeard OS"
export DISTRO_PATHNAME="neckbeard-os"
export DISTRO_VERSION="0.1.0"
export ARCH="x86_64"

# Download URLs
export MUSL_CROSS_URL="https://musl.cc/$ARCH-linux-musl-cross.tgz"
export TOOLCHAIN_URL="https://github.com/neckbeard-os/toolchain/archive/v0.9.9.tar.gz"
export KERNEL_URL="https://github.com/neckbeard-os/linux.git"

# Folders
export BASE_DIR="$(pwd)"
export WORKSPACE_DIR="$BASE_DIR/workspace"
export DOWNLOADS_DIR="$BASE_DIR/downloads"

# Compile options
export LDFLAGS="--static"
export CROSS_COMPILE=../x86_64-linux-musl-cross/bin/x86_64-linux-musl-
# make toybox
export CFLAGS="-target x86_64-pc-linux-musl --sysroot ../x86_64-linux-musl-cross"
export LDFLAGS="-static"
export CORES="$(nproc)"

# Filename
export FILENAME="$DISTRO_PATHNAME-$DISTRO_VERSION-$ARCH.iso"

# Colors
export BOLD="$(tput bold)"
export RED="$(tput setaf 1)"
export GREEN="$(tput setaf 2)"
export YELLOW="$(tput setaf 3)"
export RESET="$(tput sgr0)"
