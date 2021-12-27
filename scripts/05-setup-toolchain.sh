#!/bin/sh

download_architecture_musl_cross () {
  if [ ! -d "$ARCH-linux-musl-cross" ]; then
    log "Downloading" "$ARCH-linux-musl-cross.tgz"
    wget "$MUSL_CROSS_URL" -q --show-progress --progress=bar:force 2>&1

    log "Extracting" "$ARCH-linux-musl-cross.tgz"
    tar -xf "$ARCH-linux-musl-cross.tgz" --checkpoint=.100 || exit

    echo
    rm -rf "$ARCH-linux-musl-cross.tgz"
  fi
}

download_cross_make () {
  if [ ! -d "musl-cross-make-$CROSS_MAKE_VERSION" ]; then
    log "Downloading" "v$CROSS_MAKE_VERSION.tar.gz"
    wget "$CROSS_MAKE_URL" -q --show-progress --progress=bar:force 2>&1

    log "Extracting" "v$CROSS_MAKE_VERSION.tar.gz"
    tar -xf "v$CROSS_MAKE_VERSION.tar.gz" --checkpoint=.100 || exit

    echo
    rm -rf "v$CROSS_MAKE_VERSION.tar.gz"
  fi
}

download_toolchain () {
  cd "$DOWNLOADS_DIR" || exit

  download_architecture_musl_cross
  download_cross_make
}

setup_toolchain () {
  download_toolchain

  cd "$DOWNLOADS_DIR/musl-cross-make-$CROSS_MAKE_VERSION" || exit

  log "Building toolchain"
  
  mv config.mak.dist config.mak
  echo "TARGET = $ARCH-linux-musl" >> config.mak
  
  make -j"$CORES"
}
