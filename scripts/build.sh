#!/bin/sh

# -----------------------------------------
# This is the build script for Neckbeard OS
# -----------------------------------------

# shellcheck disable=SC1091

. ./01-config.sh
. ./02-utilities.sh
. ./03-screens.sh
. ./04-prepare-workspace.sh
. ./05-setup-toolchain.sh
. ./06-compile-utilities.sh

build_all () {
  prepare_workspace
  setup_toolchain

  compile_utilities

  success "(⌐■_■)"
}

has_root
welcome_screen
has_decent_cpu

if [ -n "$1" ]; then
  case "$1" in
    "--all") build_all ;;
    # "--prepare-workspace") prepare_workspace ;;
    # "--setup-toolchain") setup_toolchain ;;
    # "--compile-utilities") compile_utilities ;;
    # "--compile-kernel") compile_kernel ;;
    # "--setup-rootfs") setup_rootfs ;;
    # "--setup-init") setup_init ;;
    # "--setup-bootloader") setup_bootloader ;;
    # "--create-iso") create_iso ;;
    "--help") help_screen ;;
  esac
fi

if [ -z "$1" ]; then
  help_screen
fi
