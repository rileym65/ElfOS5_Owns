PROJECT = owns
INCDIR=../../Include
LIBDIR=../../Lib
INSTDIR=../../Image/bin
OBJS = \
	addname.prg \
	data.prg \
	delname.prg \
	ishex.prg \
	main.prg \
	scandir.prg \
	scanfile.prg

.SUFFIXES: .asm .prg

$(PROJECT).bin: $(OBJS)
#	asm02 -l -L -I$(INCDIR) main.asm
	link02 -s -S symbols.sym -e @link.lnk -L $(LIBDIR) -o $(PROJECT).bin

.asm.prg:
	asm02 -l -L -I$(INCDIR) $<

clean:
	-rm *.prg
	-rm *.bin
	-rm *.lst
	-rm symbols.sym

lists:
	adjlst data.lst data
	adjlst ishex.lst ishex
	adjlst scandir.lst scandir
	adjlst scanfile.lst scanfile


install: $(PROJECT).bin
	cp $(PROJECT).bin $(INSTDIR)

