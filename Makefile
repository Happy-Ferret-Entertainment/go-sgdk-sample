MARSDEV ?= ${HOME}/mars
MARSBIN  = $(MARSDEV)/m68k-elf/bin
TOOLSBIN = $(MARSDEV)/bin

GOPATH = ./

CC   = $(MARSBIN)/m68k-elf-gcc
GO   = $(MARSBIN)/m68k-elf-gccgo
AS   = $(MARSBIN)/m68k-elf-as
LD   = $(MARSBIN)/m68k-elf-ld
NM   = $(MARSBIN)/m68k-elf-nm
OBJC = $(MARSBIN)/m68k-elf-objcopy

# Z80 Assembler to build XGM driver
ASMZ80   = $(TOOLSBIN)/sjasm
# SGDK Tools
BINTOS   = $(TOOLSBIN)/bintos
LZ4W     = java -jar $(TOOLSBIN)/lz4w.jar
RESCOMP  = $(TOOLSBIN)/rescomp
WAVTORAW = $(TOOLSBIN)/wavtoraw
XGMTOOL  = $(TOOLSBIN)/xgmtool
# Sik's Tools
MDTILER  = $(TOOLSBIN)/mdtiler
SLZ      = $(TOOLSBIN)/slz
UFTC     = $(TOOLSBIN)/uftc

# Some files needed are in a versioned directory
GCC_VER := $(shell $(CC) -dumpversion)
PLUGIN   = $(MARSDEV)/m68k-elf/libexec/gcc/m68k-elf/$(GCC_VER)
LTO_SO   = liblto_plugin.so
ifeq ($(OS),Windows_NT)
	LTO_SO = liblto_plugin-0.dll
endif

INCS     = -Isrc -Ires -Iinc
LIBS     = -L$(MARSDEV)/m68k-elf/lib -lmd
GOFLAGS  = -m68000 -Wall -Wextra
CCFLAGS  = -m68000 -Wall -Wextra -std=c99 -ffreestanding
OPTIONS  = 
ASFLAGS  = -m68000 --register-prefix-optional
LDFLAGS  = -T $(MARSDEV)/ldscripts/sgdk.ld -nostdlib

RESS  = $(wildcard res/*.res)
GOS   = src/joy.go src/vdp.go src/res.go src/gomd.go
CS    = $(shell find src/ -type f -name '*.c')
SS    = $(shell find src/ -type f -name '*.s')
OBJS  = $(RESS:.res=.o)
OBJS += $(GOS:.go=.o)
OBJS += $(CS:.c=.o)
OBJS += $(SS:.s=.o)

.SECONDARY: gomd.elf

.PHONY: all release debug main-build
all: release

release: OPTIONS  = -O3 -fno-web -fno-gcse -fno-unit-at-a-time -fomit-frame-pointer
release: OPTIONS += -frename-registers -flto -fuse-linker-plugin
release: main-build symbol.txt

# Gens-KMod, BlastEm and UMDK support GDB tracing, enabled by this target
debug: OPTIONS = -g -Og -DDEBUG -DKDEBUG
debug: main-build symbol.txt

main-build: gomd.bin

# Cross reference symbol.txt with the addresses displayed in the crash handler
symbol.txt: gomd.bin
	$(NM) --plugin=$(PLUGIN)/$(LTO_SO) -n gomd.elf > symbol.txt

boot.o:
	$(AS) $(ASFLAGS) boot.s -o $@

%.bin: %.elf
	@echo "Stripping ELF header..."
	@$(OBJC) -O binary $< temp.bin
	@dd if=temp.bin of=$@ bs=8192 conv=sync
	@rm -f temp.bin

%.elf: boot.o $(PATS) $(OBJS)
	$(CC) -o $@ $(LDFLAGS) boot.o $(OBJS) $(LIBS)

%.o: %.go
	@echo "GO $<"
	@$(GO) $(GOFLAGS) $(OPTIONS) $(INCS) -c $< -o $@

%.o: %.c
	@echo "CC $<"
	@$(CC) $(CCFLAGS) $(OPTIONS) $(INCS) -c $< -o $@

%.o: %.s 
	@echo "AS $<"
	@$(AS) $(ASFLAGS) $< -o $@

%.s: %.res
	$(RESCOMP) $< $@

.PHONY: clean
clean:
	rm -f $(OBJS) gomd.bin gomd.elf symbol.txt boot.o
	rm -f res/resources.h res/resources.s
