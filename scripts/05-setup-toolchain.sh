#!/bin/sh

# https://musl.cc/aarch64-linux-musl-cross.tgz
# https://more.musl.cc/8/x86_64-linux-musl/riscv32-linux-musl-cross.tgz
# https://musl.cc/riscv64-linux-musl-cross.tgz
# https://musl.cc/x86_64-linux-musl-cross.tgz

download_architecture_dependencies () {
  if [ ! -d "$ARCH-linux-musl-cross" ]; then
    log "Downloading" "$ARCH-linux-musl-cross.tgz"
    wget "https://musl.cc/$ARCH-linux-musl-cross.tgz" -q --show-progress --progress=bar:force 2>&1

    log "Extracting" "$ARCH-linux-musl-cross.tgz"
    tar -xf "$ARCH-linux-musl-cross.tgz" --checkpoint=.100 || exit

    echo
    rm -rf "$ARCH-linux-musl-cross.tgz"
  fi
}

download_toolchain () {
  cd "$DOWNLOADS_DIR" || exit

  download_architecture_dependencies

  github_fetch "neckbeard-os/toolchain"
}

setup_toolchain () {
  download_toolchain

  cd "$DOWNLOADS_DIR/toolchain" || exit

  log "Building toolchain"
  
  mv config.mak.dist config.mak
  echo "TARGET = $ARCH-linux-musl" >> config.mak
  
  make -j"$CORES"
}
