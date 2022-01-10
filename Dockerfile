# Thanks to @ZendaiOwl for help with this one

FROM debian:latest

RUN set -x
RUN apt-get update -y
RUN apt-get install -y g++ make gawk wget curl binutils xz-utils tar zip bzip2 texinfo \
bison flex build-essential ncurses-base ncurses-term libncurses5-dev ncdu tty-clock colorize \
nano-tiny libtinfo6 libncursesw6 libncurses6 libncurses-dev rsync

COPY . ./docker
WORKDIR ./docker
