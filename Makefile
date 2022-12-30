LD = i686-elf-ld
GCC = i686-elf-gcc
INCLUDE = -I./include
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

ROOT_DIR=/home/mohamed/Projects/os/project-1/
FILES = ./build/kernel/kernel.asm.o ./build/kernel/kernel.o ./build/fs/pparse.o ./build/vga/vga.o ./build/idt/idt.o ./build/idt/idt.asm.o ./build/utils/utils.o ./build/utils/string/string.o ./build/io/io.asm.o ./build/memory/memory.o ./build/memory/heap/heap.o ./build/memory/heap/kheap.o ./build/memory/paging/paging.o ./build/memory/paging/paging.asm.o ./build/disk/disk.o ./build/disk/disk_stream.o


all: create_build_dir ./bin/boot.bin ./bin/kernel/bin 
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=1048576 count=16 >> ./bin/os.bin
	# mount os.bin to /mnt/d and copy from root -> /mnt/d
	sudo mount -t vfat ./bin/os.bin /mnt/d
	# copies files to system directory 
	sudo cp root/hello_world.txt /mnt/d
	sudo umount /mnt/d

create_build_dir:  
	mkdir bin/
	mkdir build/
	mkdir build/boot/
	mkdir build/kernel/
	mkdir build/utils/
	mkdir build/utils/string/
	mkdir build/vga/
	mkdir build/idt/
	mkdir build/io/
	mkdir build/disk/
	mkdir build/fs/
	mkdir build/memory/
	mkdir build/memory/heap/
	mkdir build/memory/paging/

./bin/boot.bin : ./src/boot/boot.asm
	nasm -f bin $^ -o $@

./bin/kernel/bin: $(FILES)
	$(LD) -g -relocatable $(FILES) -o ./build/kernelfull.o	
	$(GCC) $(FLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o 

./build/kernel/kernel.asm.o: ./src/kernel/kernel.asm
	nasm -f elf -g $^ -o $@

./build/idt/idt.asm.o: ./src/idt/idt.asm
	nasm -f elf -g $^ -o $@

./build/io/io.asm.o: ./src/io/io.asm
	nasm -f elf -g $^ -o $@

./build/memory/paging/paging.asm.o: ./src/memory/paging/paging.asm
	nasm -f elf -g $^ -o $@



./build/kernel/kernel.o: ./src/kernel/kernel.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/vga/vga.o: ./src/vga/vga.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/utils/utils.o:  ./src/utils/utils.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/utils/string/string.o:  ./src/utils/string/string.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/idt/idt.o: ./src/idt/idt.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/memory/memory.o: ./src/memory/memory.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/memory/heap/heap.o: ./src/memory/heap/heap.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/memory/heap/kheap.o: ./src/memory/heap/kheap.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/memory/paging/paging.o: ./src/memory/paging/paging.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/disk/disk.o: ./src/disk/disk.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/disk/disk_stream.o: ./src/disk/disk_stream.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@

./build/fs/pparse.o: ./src/fs/pparser.c
	$(GCC) $(INCLUDE) $(FLAGS) -std=gnu99 -c $^ -o $@


clean:
	rm -rf bin
	rm -rf build


