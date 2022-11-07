# syntax=docker/dockerfile:1
# Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com>
# https://github.com/ZendaiOwl
# gcc-aarch64-linux-gnu gcc-arm-linux-gnu libgccjit libgcc gcc

FROM fedora:latest

# FROM --platform=$BUILDPLATFORM fedora

RUN set -x
RUN dnf update -y
RUN dnf install -y patch make gawk wget curl git cronie \
    xz pxz tar zip bzip2 texinfo bison flex ncurses coreutils diffutils findutils \
    grep gzip tar sed ncurses-term ncurses-base ncurses-libs \
    boost-build build2 ncdu colorize nano \
    rsync gcc libgcc gcc-aarch64-linux-gnu bash gcc-c++ \
    libstdc++ glibc gmp-devel libmpc-devel mpfr-devel cloog-devel isl-devel && dnf clean all

COPY . ./docker
WORKDIR /docker
