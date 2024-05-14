OBJS	= Nonary2IntVol.o
ASM		= yasm -g dwarf2 -f elf64
LD		= ld -g

all: Nonary2IntVol

Nonary2IntVol.o: Nonary2IntVol.asm 
	$(ASM) Nonary2IntVol.asm -l Nonary2IntVol.lst

Nonary2IntVol: Nonary2IntVol.o
	$(LD) -o Nonary2IntVol $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm	Nonary2IntVol.lst
