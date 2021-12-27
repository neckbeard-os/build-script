#!/bin/sh

prepare_workspace () {
  if [ ! -d "$WORKSPACE_DIR" ]; then
    log "Creating" "$WORKSPACE_DIR"

    mkdir --parents "$WORKSPACE_DIR" || exit
    mkdir --parents "$WORKSPACE_DIR"/iso/boot || exit
    mkdir --parents "$WORKSPACE_DIR"/iso/isolinux || exit
  fi

  if [ ! -d "$DOWNLOADS_DIR" ]; then
    log "Creating" "$DOWNLOADS_DIR"
    mkdir --parents "$DOWNLOADS_DIR" || exit
  fi
}
