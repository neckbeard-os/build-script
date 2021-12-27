# Thanks to @ZendaiOwl for help with this one

FROM debian:latest

RUN apt-get update

RUN apt install -y --no-install-recommends \
clang gcc cross-gcc-dev ca-certificates build-essential libncurses5 libncurses5-dev \
bison flex libelf-dev libssl-dev bc xorriso make xz-utils file gawk wget tar rsync \
zsh pv nano lzip texinfo sed gzip qemu qemu-system-x86 cpio grub-common zstd git

COPY . /docker
WORKDIR /docker

RUN chmod +x ./scripts/build.sh
