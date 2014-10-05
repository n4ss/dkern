# Makefile for dkern

LD = ld
DC = gdc
CC = gdc
ASM = nasm
QEMU = qemu-system-i386

KERNEL_IMG=kernel

QEMU_FLAGS = -cdrom
QEMU_DBG_FLAGS = -s -S

CFLAGS = -nostdlib -g -m32
DFLAGS = -nostdlib -nodefaultlibs -g -m32
LDFLAGS = -nostdlib -nodefaultlibs --verbose=3 -m elf_i386
NASMFLAGS = -felf

DFILES = gdt.d utils.d runtime.d kernel.main.d
ASMFILES = start.asm
LDSCRIPT = linker.ld

OBJS = $(ASMFILES:.asm=.o) $(DFILES:.d=.o)

ISO_PATH = isodir/
BOOT_PATH = boot/
GRUB_PATH = boot/grub/

GRUB_CFG = grub.cfg
define GRUB_CONFIG
menuentry \"kernel\" {
	multiboot /$(BOOT_PATH)$(KERNEL_IMG)
	}
endef

export GRUB_CONFIG

all: setup $(PROG)
	@echo ""
	@echo "dkern successfully compiled"
	@echo ""

.asm.o:
	@echo "Launching rule $@"
	$(ASM) $(NASMFLAGS) -o $@ $<

%.o: %.d
	@echo "Launching rule $@"
	$(DC) $(DFLAGS) -c $< -o $@

$(KERNEL_IMG): $(OBJS)
	@echo "Launching rule $(KERNEL_IMG)"
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

iso:
	@echo "Launching rule iso"
	mkdir -p $(ISO_PATH)$(BOOT_PATH)
	cp $(KERNEL_IMG) $(ISO_PATH)$(BOOT_PATH)
	mkdir -p $(ISO_PATH)$(GRUB_PATH)
	cp $(GRUB_CFG) $(ISO_PATH)$(GRUB_PATH)
	grub-mkrescue -o $(KERNEL_IMG).iso $(ISO_PATH)

boot:
	$(QEMU) $(QEMU_FLAGS) $(KERNEL_IMG).iso

debug:
	$(QEMU) $(QEMU_DBG_FLAGS) $(QEMU_FLAGS) $(KERNEL_IMG).iso

setup:
	@echo "Launching rule setup"
	@echo "$$GRUB_CONFIG" > grub.cfg

clean:
	rm -f $(OBJS) $(KERNEL_IMG)

distclean: clean
	rm -f $(KERNEL_IMG).iso
	rm -f $(GRUB_CFG)
	rm -rf ./$(ISO_PATH)
