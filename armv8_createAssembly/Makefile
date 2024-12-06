ARMGNU ?= aarch64-linux-gnu

AOPS = --warn --fatal-warnings

asm : archivo.list

all : asm

clean :
	rm -f *.o
	rm -f *.img
	rm -f *.hex
	rm -f *.list
	rm -f *.elf
	rm -f memory_map.txt

archivo.o : archivo.s
	$(ARMGNU)-as $(AOPS) archivo.s -o archivo.o


archivo.list: memmap archivo.o 
	$(ARMGNU)-ld archivo.o -T memmap -o archivo.elf -M > memory_map.txt
	$(ARMGNU)-objdump -D archivo.elf > archivo.list
	
