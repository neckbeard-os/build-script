# @Victor-ray, S. <victorray91@pm.me> 
# https://github.com/ZendaiOwl
# 

FROM fedora:latest

RUN set -x
RUN dnf update -y
RUN dnf install -y patch make gawk wget curl git cronie binutils \
    xz pxz tar zip bzip2 texinfo bison flex ncurses \
    ncurses-term ncurses-base ncurses-libs \
    boost-build build2 ncdu binclock colorize nano \
    rsync clang musl-clang && dnf clean all

COPY . ./docker
WORKDIR /docker
