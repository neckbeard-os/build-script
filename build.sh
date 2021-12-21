#!/bin/sh

# -----------------------------------------
# This is the build script for Neckbeard OS
# -----------------------------------------

# Package versions
export CROSS_MAKE_VERSION="0.9.9"
export TOYBOX_VERSION="0.8.4" # 0.8.6 is weird :P
export KERNEL_VERSION="5.15.6"

# Download URLs
export MUSL_CROSS_URL="https://musl.cc/x86_64-linux-musl-cross.tgz"
export CROSS_MAKE_URL="https://github.com/richfelker/musl-cross-make/archive/v$CROSS_MAKE_VERSION.tar.gz"
export KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.xz"
export TOYBOX_URL="https://github.com/landley/toybox/archive/$TOYBOX_VERSION.tar.gz"

# Folders
export BASE_DIR="$(pwd)"
export WORKSPACE_DIR="$BASE_DIR/workspace"
export DOWNLOADS_DIR="$BASE_DIR/downloads"

# Compile options
export ARCH="x86_64"
export THREADS=$(nproc)

# Text
export BOLD="$(tput bold)"
export RED="$(tput setaf 1)"
export GREEN="$(tput setaf 2)"
export MAGENTA="$(tput setaf 5)"
export WHITE="$(tput setaf 7)"
export RESET="$(tput sgr0)"


echo "Hello"
