# flags
AFLAGS      = -g -f elf32
LDFLAGS     = -g -m elf_i386

# commands
ASM         = nasm
LD          = ld
RM          = rm -rf
MKDIR       = mkdir  -p
ASSEMBLE    = $(ASM) $(AFLAGS)
LINK        = $(LD) $(LDFLAGS)
INSTALL     = install

# directories
BINDIR      = ../bin
LOCALBIN    = ~/.local/bin

# targets
TARGETS     = bfi
LIBRARIES   = bfi
INCLUDES    = constants.inc
OBJECTS     = $(foreach OBJ, $(LIBRARIES), $(addsuffix .o, $(OBJ)))

###  RULES  ######################################################################

.PHONY: all  clean  install  uninstall

all: $(TARGETS)

$(TARGETS): $(OBJECTS) $(INCLUDES) | $(BINDIR)
	$(LINK) -o $(BINDIR)/$@ $(OBJECTS)

$(OBJECTS): %.o: %.asm
	$(ASSEMBLE) $<

$(BINDIR):
	$(MKDIR) $(BINDIR)

clean:
	$(RM) $(foreach EXE , $(TARGETS), $(wildcard $(BINDIR)/$(EXE)))
	$(RM) $(foreach OBJ , $(OBJECTS), $(OBJ))

install:
	$(MKDIR) $(LOCALBIN)
	$(INSTALL) $(foreach EXE , $(TARGETS), $(wildcard $(BINDIR)/$(EXE))) \
		$(LOCALBIN)
