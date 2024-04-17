# clang based compilation. 

CC = clang
#LD = ld

.PHONY: run

#mbr : mbr.S
#	$(CC) -fPIC $^ -ffreestanding -nostdlib -m16 --target=i386-unknown-linux -fuse-ld=lld \
#		 -Wl,-Ttext=0x7c00,--oformat=binary,--nmagic,-static -o $@.temp
#	dd if=$@.temp count=1 of=mbr
#

boot: mbr kernel
	cat $^ > boot
mbr : mbr.S
	$(CC) -fPIC $^ --verbose -ffreestanding -static -nostdlib -m16 --target=i386-none-linux \
		 -Wl,--oformat=binary,-Ttext=0x7c00,--nmagic,-static -o $@
kernel : kernel_entry.S kernel.c kernel.ld
	$(CC) --verbose kernel_entry.S kernel.c -ffreestanding -fomit-frame-pointer -static -nostdlib -m16 \
		--target=x86_64-none-linux -mno-sse -mno-mmx \
		-Wl,-Tkernel.ld,--oformat=binary \
		-o $@.temp
	dd if=/dev/zero bs=1 count=$$(echo $$((512 - `wc -c < kernel.temp`%512))) >> $@.temp
	cp $@.temp $@
	cat dneko.vga >> $@
#	$(CC) -include code16gcc.S --verbose -fPIC kernel.c --target=i386-none-linux -ffreestanding -fomit-frame-pointer \
#		-static -nostdlib -m16 -mno-sse -S -mno-mmx -mcpu=i386 -o kernel.S
#	# some shitty compiler omits .code16 the the assembly
#	echo .code16 > c16
#	cat c16 kernel.S > c16kernel.S
#	$(CC) --verbose -c -fPIC c16kernel.S --target=i386-none-linux -ffreestanding -fomit-frame-pointer \
#		-static -nostdlib -m16 -mno-sse -mno-mmx -mcpu=i386 -o kernel.o
#	$(CC) -c -fPIC kernel_entry.S -ffreestanding -fomit-frame-pointer -static -nostdlib -m16 \
#		-mno-sse -mno-mmx --target=x86_64-none-linux -o kernel_entry.o
#	$(LD) --eh-frame-hdr -m elf_i386 -static -o $@ kernel.o kernel_entry.o --oformat=binary -Ttext=0x7e00 --nmagic -static
kernel.S : kernel.c
	$(CC) -fPIC -S $^ -ffreestanding -fomit-frame-pointer -mno-sse -static -nostdlib -m16 \
		--target=x86_64-none-linux -o $@
run : boot
	qemu-system-x86_64 boot
clean: boot mbr kernel
	rm $^

