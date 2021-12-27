#!/bin/sh

compile_kernel () {
  cd "$DOWNLOADS_DIR" || exit

  if [ ! -d "linux" ]; then
    echo "Cloning Linux"
    git clone "$KERNEL_URL"
  fi
  
  cd linux || exit

  make tinyconfig
  make nconfig
  make clean
  make bzImage

  # make x86_64_defconfig
  # make -j $(nproc)

  # make CC=x86_64-linux-musl-gcc LDFLAGS=-static  defconfig
  # make CC=x86_64-linux-musl-gcc LDFLAGS=-static -j $(nproc)

  cp "$DOWNLOADS_DIR/linux/arch/$ARCH/boot/bzImage" "$WORKSPACE_DIR/iso/isolinux/bzImage"
}
