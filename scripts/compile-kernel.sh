#!/bin/sh

compile_kernel () {
  cd "$DOWNLOADS_DIR" || exit

  if [ ! -d "linux" ]; then
    log "Downloading" "Linux"
    github_fetch "torvalds/linux"
  fi

  cd "linux" || exit

  make tinyconfig
  make nconfig
  make clean
  make bzImage

  cp "$DOWNLOADS_DIR/linux/arch/$ARCH/boot/bzImage" "$WORKSPACE_DIR/iso/isolinux/bzImage"
}

# make x86_64_defconfig
# make -j $(nproc)

# make CC=x86_64-linux-musl-gcc LDFLAGS=-static  defconfig
# make CC=x86_64-linux-musl-gcc LDFLAGS=-static -j $(nproc)
