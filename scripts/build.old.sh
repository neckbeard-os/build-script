#!/bin/sh

# -----------------------------------------
# This is the build script for Neckbeard OS
# -----------------------------------------


download_syslinux () {
  if [ ! -d "syslinux-$SYSLINUX_VERSION" ]; then
    log "Downloading" "syslinux-$SYSLINUX_VERSION.tar.xz"
    wget $SYSLINUX_URL -q --show-progress --progress=bar:force 2>&1

    log "Extracting" "syslinux-$SYSLINUX_VERSION.tar.xz"
    tar -xf "syslinux-$SYSLINUX_VERSION.tar.xz" --checkpoint=.100 || exit

    echo
    rm -rf "syslinux-$SYSLINUX_VERSION.tar.xz"
  fi
}

download_kernel () {
  if [ ! -d "linux-$KERNEL_VERSION" ]; then
    log "Downloading" "linux-$KERNEL_VERSION.tar.xz"
    wget $KERNEL_URL -q --show-progress --progress=bar:force 2>&1

    log "Extracting" "linux-$KERNEL_VERSION.tar.xz"
    tar -xf "linux-$KERNEL_VERSION.tar.xz" --checkpoint=.100 || exit

    echo
    rm -rf "linux-$KERNEL_VERSION.tar.xz"
  fi
}

download_toybox () {
  if [ ! -d "toybox-$TOYBOX_VERSION" ]; then
    log "Downloading" "toybox-$TOYBOX_VERSION.tar.xz"
    wget $TOYBOX_URL -q --show-progress --progress=bar:force 2>&1

    log "Extracting" "toybox-$TOYBOX_VERSION.tar.xz"
    mv "$TOYBOX_VERSION.tar.gz" "toybox-$TOYBOX_VERSION.tar.xz"
    tar -xf "toybox-$TOYBOX_VERSION.tar.xz" --checkpoint=.100 || exit

    echo
    rm -rf "toybox-$TOYBOX_VERSION.tar.xz"
  fi
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
setup_toolchain () {
  cd "$DOWNLOADS_DIR/musl-cross-make-$CROSS_MAKE_VERSION" || exit

  log "Building toolchain"
  
  mv config.mak.dist config.mak
  echo "TARGET = x86_64-linux-musl" >> config.mak
  
  make -j"$CORES"
}


# --------------
# Compile Toybox
# --------------
compile_toybox () {
  cd "$DOWNLOADS_DIR/toybox-$TOYBOX_VERSION" || exit

  log "Compiling" "toybox"

  make clean
  make defconfig

  # Build static toybox with musl-cross-make gcc toolchain
  LDFLAGS="--static" CROSS_COMPILE=$DOWNLOADS_DIR/$ARCH-linux-musl-cross/bin/$ARCH-linux-musl- make toybox

  mv toybox "$WORKSPACE_DIR/"
  #exit

  # Build static with clang using musl-cross-make as sysroot
  CFLAGS="-target $ARCH-pc-linux-musl --sysroot $DOWNLOADS_DIR/$ARCH-linux-musl-cross" LDFLAGS="-static" CC=clang make toybox
}


# --------------
# Compile Kernel
# --------------
compile_kernel () {
  log "Compiling" "kernel"

  # PATH="$(realpath .)/$ARCH-linux-musl-cross/bin":$PATH
  PATH=$(realpath .)/$ARCH-linux-musl-cross/bin:$PATH

  cd "$DOWNLOADS_DIR/toybox-$TOYBOX_VERSION" || exit
  
  make root CROSS_COMPILE=$ARCH-linux-musl- LINUX="$DOWNLOADS_DIR/linux-$KERNEL_VERSION"

  mv "root/$ARCH/" "$WORKSPACE_DIR/"
}


# ------------
# Setup rootfs
# ------------
setup_rootfs () {
  log "Setup" "rootfs"
}


# ----------------
# Setup bootloader
# ----------------
setup_bootloader () {
  log "Setup" "bootloader"
}


# ---------
# Build ISO
# ---------
build_iso () {
  grub-mkrescue -o "$BASE_DIR/$FILENAME" "$WORKSPACE_DIR/iso"
  # xorriso -as mkisofs -o "$BASE_DIR/$FILENAME" -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ./
}


# ---------
# Build all
# ---------
build_all () {
  prepare_workspace
  download_dependencies
  setup_toolchain

  compile_toybox
  compile_kernel
  # setup_rootfs
  # setup_bootloader

  success "(⌐■_■)"
}


# ----
# Main
# ----
has_root
welcome_screen
has_decent_cpu

if [ -n "$1" ]; then
  case "$1" in
    "--all") build_all ;;
    "--prepare-workspace") prepare_workspace ;;
    "--download-dependencies") download_dependencies ;;
    "--setup-toolchain") setup_toolchain ;;
    "--compile-toybox") compile_toybox ;;
    "--compile-kernel") compile_kernel ;;
    "--setup-rootfs") setup_rootfs ;;
    "--setup-bootloader") setup_bootloader ;;
    "--help") help_screen ;;
  esac
fi

if [ -z "$1" ]; then
  help_screen
fi
