<!-- Victor-ray, S. <12261439+ZendaiOwl@users.noreply.github.com> https://github.com/ZendaiOwl -->

## RISC-V 

GNU Toolchain for RISC-V architecture

**WARNING**: git clone takes around 6.65 GB of disk and download size

Dependencies _(Debian)_

- autoconf
- automake
- autotools-dev
- libmpc-dev
- libmpfr-dev
- libgmp-dev
- libtool
- zlib1g-dev
- libexpat-dev
- curl
- python3
- gawk
- build-essential
- bison
- flex
- texinfo
- gperf
- patchutils
- bc

If you have started a new GitHub Codespace Debian container, run the command below to be able to build the GNU RISC-V Toolchain.

```bash
sudo apt-get update -y && \
sudo apt-get install -y autoconf automake autotools-dev curl python3 \
libmpc-dev libmpfr-dev libgmp-dev libtool zlib1g-dev libexpat-dev \
gawk build-essential bison flex texinfo gperf patchutils bc
```

Working configuration _(At the moment anyway)_

```bash
BINUTILS_VER = 2.33.1
GCC_VER = 10.3.0
MUSL_VER = git-master
GMP_VER = 6.1.2
MPC_VER = 1.1.0
MPFR_VER = 4.0.2
ISL_VER = 0.15
LINUX_VER = 5.8.5
```

---

## Not RISC-V below

╔════════════════╗  
║  Build Script  ║  
╚════════════════╝  
________________________________________________________________________

This is the build script that will create a minimal Linux system  
utilizing toybox, clang/llvm and musl libc

╔═══════════════╗  
║  Disclaimer   ║  
╚═══════════════╝  
________________________________________________________________________

Still under heavy development and isnt even in alpha stage right now  
The main branch will remain the dev branch until 1.0  

╔═══════════════╗  
║  Development  ║  
╚═══════════════╝  
________________________________________________________________________

<s>docker-compose up --build -d  
docker exec -it build-script-build-1 sh  
cd scripts  
./build.sh --all  

docker-compose down --remove-orphans </s>
________________________________________________________________________
♠ ♥ ♣ ♦ 🔒  
╔════════════════╗  
║   @ZendaiOwl   ║  
╚════════════════╝  
Launch with  
࿓❯ ./start.sh  
