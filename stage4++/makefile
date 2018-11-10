# Create the boot loader binaries

.DEFAULT_GOAL:=all

.SUFFIXES: .img .bin .asm .sys .o .lib
.PRECIOUS: %.o

IMAGE=uodos

%.bin: %.asm
	nasm -w+all -f bin -o $@ $<
	
boot.bin: boot.asm print_functions_16_SF.asm
boot2.bin: boot2.asm print_functions_16_SF.asm graphics_main.asm\
animation_circle.asm animation_circle_q1.asm animation_circle_q2.asm animation_circle_q3.asm animation_circle_q4.asm animation_circle_finish.asm\
print_functions_graphics.asm

$(IMAGE).img: boot.bin boot2.bin
#	Get the blank disk image
	cp diskimage/uodos.img $(IMAGE).img
#	Copy the boot sector over to the disk image
	dd status=noxfer conv=notrunc if=boot.bin of=$(IMAGE).img
	dd status=noxfer conv=notrunc seek=1 if=boot2.bin of=$(IMAGE).img
	
all: $(IMAGE).img

clean:
	rm -f boot.bin
	rm -f boot2.bin
	rm -f $(IMAGE).img
	rm -f $(IMAGE).img.lock

remake:
	make clean
	@echo ""
	@echo ""
	make
	@echo ""
	@echo ""

run:
	cmd /K "[full_path]\bochsrc.bxrc"
