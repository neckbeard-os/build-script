╔════════╗  
║ Build Script ║  
╚════════╝  
________________________________________________________________________

This is the build script that will create a minimal Linux system  
utilizing toybox, clang/llvm and musl libc

╔═══════╗  
║Disclaimer ║  
╚═══════╝  
________________________________________________________________________

Still under heavy development and isnt even in alpha stage right now  
The main branch will remain the dev branch until 1.0  

╔════════╗  
║Development║  
╚════════╝  
________________________________________________________________________

<s>docker-compose up --build -d  
docker exec -it build-script-build-1 sh  
cd scripts  
./build.sh --all  

docker-compose down --remove-orphans </s>
________________________________________________________________________
♠ ♥ ♣ ♦ 🔒  
╔════════╗  
║@ZendaiOwl║  
╚════════╝  
Launch with  
࿓❯ ./start.sh  
	It will create a container and then execute ./launch.sh  
࿓❯ ./launch.sh  
	It will enter the docker container and execute the build-gcc.sh/build-musl.sh script  
࿓❯ docker/scripts/gcc-build/build-gcc.sh  
࿓❯ docker/scripts/gcc-build/build-musl.sh  
