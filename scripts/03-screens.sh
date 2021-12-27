#!/bin/sh

help_screen () {
  cat <<EOF
${BOLD}Available commands${RESET}
  --all
  --prepare-workspace
  --download-dependencies
  --setup-toolchain
  --compile-toybox
  --compile-kernel
  --setup-rootfs
  --setup-bootloader
EOF
}

welcome_screen () {
  cat <<EOF

This is the build script for ${BOLD}${GREEN}${DISTRO_NAME}${RESET}

It will setup our cross-compiler toolchain
Download the source and compile it for the ${BOLD}${ARCH}${RESET} arch

And generate a Live CD ISO

EOF
}
