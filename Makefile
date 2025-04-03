CC=fpc
CFLAGS=-Fu./include/ -Fl./lib/ -Px86_64
EXAMPLESDIR=./examples/
EXAMPLES=squares helloworld
EXAMPLESTARGETS=$(addsuffix .exe,$(addprefix $(EXAMPLESDIR),$(EXAMPLES)))

.PHONY: examples clean

$(EXAMPLESDIR)%.exe:
	$(CC) $(CFLAGS) $(EXAMPLESDIR)/$*.pp -o$(EXAMPLESDIR)/$*.exe

examples: $(EXAMPLESTARGETS)

clean:
	rm -f $(EXAMPLESDIR)/*.exe
	rm -f $(EXAMPLESDIR)/*.o
	rm -f $(EXAMPLESDIR)/*.ppu