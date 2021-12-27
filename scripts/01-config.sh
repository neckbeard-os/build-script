#!/bin/sh

# shellcheck disable=SC2155

# Distro
export DISTRO_NAME="Neckbeard OS"
export DISTRO_PATHNAME="neckbeard-os"
export DISTRO_VERSION="0.1.0"
export ARCH="x86_64"

# Directories
export ROOT_DIR="$(pwd)"
export WORKSPACE_DIR="$ROOT_DIR/workspace"
export DOWNLOADS_DIR="$ROOT_DIR/downloads"

# # Toolchain options (compiler flags)
# export CFLAGS="-target $ARCH-pc-linux-musl --sysroot $DOWNLOADS_DIR/$ARCH-linux-musl-cross"
# export LDFLAGS="-static"
# export CC=clang

export CORES="$(nproc)"

# Filename
export FILENAME="$DISTRO_PATHNAME-$DISTRO_VERSION-$ARCH.iso"

# Colors
export BOLD="$(tput bold)"
export RED="$(tput setaf 1)"
export GREEN="$(tput setaf 2)"
export YELLOW="$(tput setaf 3)"
export RESET="$(tput sgr0)"
