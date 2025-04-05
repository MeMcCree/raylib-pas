CC=fpc
CINC=./include/
CUNIT=./include/
CLIB=./lib/
CFLAGS=-Fi$(CINC) -Fu$(CUNIT) -Fl$(CLIB) -Px86_64
EXAMPLESDIR=./examples/
BUILDDIR=$(EXAMPLESDIR)
EXAMPLES=squares helloworld 2dcamsystem 3dcam multisample
EXAMPLESTARGETS=$(addsuffix .exe,$(addprefix $(EXAMPLESDIR),$(EXAMPLES)))

.PHONY: examples clean

$(CUNIT)/raylib.ppu:
	$(CC) $(CFLAGS) $(CUNIT)/raylib.pp -o$(BUILDDIR)/raylib.ppu

$(EXAMPLESDIR)%.exe: $(CUNIT)/raylib.ppu
	$(CC) $(CFLAGS) $(EXAMPLESDIR)/$*.pp -o$(BUILDDIR)/$*.exe

examples: $(EXAMPLESTARGETS)

clean:
	rm -f $(EXAMPLESDIR)/*.exe
	rm -f $(EXAMPLESDIR)/*.o
	rm -f $(BUILDDIR)/*.ppu