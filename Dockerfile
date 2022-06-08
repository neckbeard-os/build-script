# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# gcc-aarch64-linux-gnu gcc-arm-linux-gnu libgccjit libgcc gcc

FROM fedora:latest

RUN set -x
RUN dnf update -y
RUN dnf install -y patch make gawk wget curl git cronie binutils \
    xz pxz tar zip bzip2 texinfo bison flex ncurses \
    ncurses-term ncurses-base ncurses-libs \
    boost-build build2 ncdu binclock colorize nano \
    rsync gcc libgcc gcc-aarch64-linux-gnu musl-gcc clang musl-clang \
    gmp-devel libmpc-devel mpfr-devel cloog-devel isl-devel gcc-c++ \
    libstdc++ && dnf clean all

COPY . ./docker
WORKDIR /docker
