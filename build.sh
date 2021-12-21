#!/bin/sh

# -----------------------------------------
# This is the build script for Neckbeard OS
# -----------------------------------------

# Distro
DISTRO_NAME="Neckbeard OS"
# DISTRO_PATHNAME="neckbeard-os"
# DISTRO_VERSION="0.1.0"

# Package versions
CROSS_MAKE_VERSION="0.9.9"
SYSLINUX_VERSION="6.03"
KERNEL_VERSION="5.15.6"
TOYBOX_VERSION="0.8.4" # 0.8.6 is weird :P

# Download URLs
MUSL_CROSS_URL="https://musl.cc/x86_64-linux-musl-cross.tgz"
CROSS_MAKE_URL="https://github.com/richfelker/musl-cross-make/archive/v$CROSS_MAKE_VERSION.tar.gz"
SYSLINUX_URL="http://kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.xz"
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.xz"
TOYBOX_URL="https://github.com/landley/toybox/archive/$TOYBOX_VERSION.tar.gz"

# Folders
BASE_DIR="$(pwd)"
WORKSPACE_DIR="$BASE_DIR/workspace"
DOWNLOADS_DIR="$BASE_DIR/downloads"

# Compile options
ARCH="x86_64"
CORES="$(nproc)"

# Filename
# FILENAME="$DISTRO_PATHNAME-$ARCH-$DISTRO_VERSION.iso"

# Colors
BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
RESET="$(tput sgr0)"

# ---------
# Utilities
# ---------
has_root () {
  if [ "$(id -u)" != 0 ]; then
    echo "${RED}Sorry, must be root to run this script${RESET}"
    exit 1
  fi
}

has_decent_cpu () {
  if [ "$CORES" -lt 4 ]; then
    echo "${BOLD}${YELLOW}Warning:${RESET} ${CORES} CPU cores, expect a long build time"
    echo ""
    sleep 1
  fi
}

log () {
  echo "${BOLD}${GREEN}➜${RESET} ${1}"
}

success () {
  echo "${BOLD}${GREEN}✔${RESET} ${1}"
}

error () {
  echo "${BOLD}${RED}¯\_(ツ)_/¯${RESET} ${1}"
  exit 1
}

# -----------------
# Prepare workspace
# -----------------
prepare_workspace () {
  if [ ! -d "$WORKSPACE_DIR" ]; then
    log "Creating $WORKSPACE_DIR folder"

    mkdir --parents "$WORKSPACE_DIR" || exit
    mkdir --parents "$WORKSPACE_DIR"/iso/boot || exit
    mkdir --parents "$WORKSPACE_DIR"/iso/isolinux || exit
  fi

  if [ ! -d "$DOWNLOADS_DIR" ]; then
    log "Creating ${DOWNLOADS_DIR} folder"
    mkdir --parents "$DOWNLOADS_DIR" || exit
  fi
}


# ------------------
# Download & Extract
# ------------------
download_musl_cross () {
  log "Downloading linux x86_64-linux-musl-cross.tgz"
  wget $MUSL_CROSS_URL -q --show-progress --progress=bar:force 2>&1

  log "Extracting x86_64-linux-musl-cross.tgz"

  tar -xf x86_64-linux-musl-cross.tgz --checkpoint=.100 || exit
  echo ""
  rm -rf x86_64-linux-musl-cross.tgz
}

download_cross_make () {
  log "Downloading cross make v$CROSS_MAKE_VERSION.tar.gz"
  wget $CROSS_MAKE_URL -q --show-progress --progress=bar:force 2>&1

  log "Extracting v$CROSS_MAKE_VERSION.tar.gz"
  tar -xf v$CROSS_MAKE_VERSION.tar.gz --checkpoint=.100 || exit
  echo ""
  rm -rf v$CROSS_MAKE_VERSION.tar.gz
}

download_toolchain () {
  download_musl_cross
  download_cross_make
}

download_syslinux () {
  log "Downloading syslinux-$SYSLINUX_VERSION.tar.xz"
  wget $SYSLINUX_URL -q --show-progress --progress=bar:force 2>&1

  log "Extracting syslinux-$SYSLINUX_VERSION.tar.xz"
  tar -xf syslinux-$SYSLINUX_VERSION.tar.xz --checkpoint=.100 || exit
  echo ""
  rm -rf syslinux-$SYSLINUX_VERSION.tar.xz
}

download_kernel () {
  log "Downloading linux-$KERNEL_VERSION.tar.xz"
  wget $KERNEL_URL -q --show-progress --progress=bar:force 2>&1

  log "Extracting linux-$KERNEL_VERSION.tar.xz"
  tar -xf linux-$KERNEL_VERSION.tar.xz --checkpoint=.100 || exit
  echo ""
  rm -rf linux-$KERNEL_VERSION.tar.xz
}

download_toybox () {
  log "Downloading toybox-$TOYBOX_VERSION.tar.xz"
  wget $TOYBOX_URL -q --show-progress --progress=bar:force 2>&1

  log "Extracting toybox-$TOYBOX_VERSION.tar.xz"
  mv $TOYBOX_VERSION.tar.gz toybox-$TOYBOX_VERSION.tar.xz
  tar -xf toybox-$TOYBOX_VERSION.tar.xz --checkpoint=.100 || exit
  echo ""
  rm -rf toybox-$TOYBOX_VERSION.tar.xz
}

download_dependencies () {
  cd "$DOWNLOADS_DIR" || exit

  download_toolchain
  download_syslinux
  download_kernel
  download_toybox
}


# ---------------
# Setup toolchain
# ---------------
build_toolchain () {
  cd "$DOWNLOADS_DIR"/musl-cross-make-"$CROSS_MAKE_VERSION" || exit

  log "Building toolchain"
  
  mv config.mak.dist config.mak
  echo 'TARGET = x86_64-linux-musl' >> config.mak
  
  make -j"$THREADS"
}


# -------
# Screens
# -------
help () {
  cat <<EOF
${BOLD}Available commands${RESET}
  --all
  --prepare-workspace
  --download-dependencies
  --setup-toolchain
EOF
}

welcome () {
  cat <<EOF

This is the build script for ${BOLD}${GREEN}${DISTRO_NAME}${RESET}

It will setup our cross-compiler toolchain
Download the source and compile it for the ${BOLD}${ARCH}${RESET} arch

And generate a Live CD ISO

EOF
}


# ---------
# Build all
# ---------
build_all () {
  prepare_workspace
  download_dependencies
  setup_toolchain

  success "All done"
}


# ----
# Main
# ----
has_root
welcome
has_decent_cpu

if [ -n "$1" ]; then
  case "$1" in
    "--all") build_all ;;
    "--prepare-workspace") prepare_workspace ;;
    "--download-dependencies") download_dependencies ;;
    "--setup-toolchain") setup_toolchain ;;
    "--help") help ;;
  esac
fi

if [ -z "$1" ]; then
  help
fi
