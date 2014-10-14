module gdt;

import utils;
import console;

struct GdtPtr {
    align (1):
    ushort limit;
    uint base;
}

struct GdtEntry {
    ushort  limit;
    ushort  base_l;
    ubyte   base_m;
    ubyte   access;
    ubyte   gran;
    ubyte   base_h;
}

__gshared GdtEntry gdt_entries[5];
__gshared GdtPtr gdt_r;

extern(C) void gdt_flush(uint gdtr);
extern(C) void set_cr0_pe();

void gdt_set_entry(uint index, uint base, uint limit,
                   ubyte access, ubyte gran) {
    gdt_entries[index].limit = limit & 0xffff;

    gdt_entries[index].base_l = base & 0xffff;
    gdt_entries[index].base_m = (base >> 16) & 0xff;
    gdt_entries[index].base_h = (base >> 24) & 0xff;

    gdt_entries[index].gran = (limit >> 16) & 0x0f;
    gdt_entries[index].gran |= gran & 0xf0;
    gdt_entries[index].access = access;
}

void init_gdt() {
    gdt_r.limit = (GdtEntry.sizeof * 5) - 1;
    gdt_r.base = cast(size_t)gdt_entries.ptr;
    memset(cast(void *)gdt_entries, 0, 5 * (GdtEntry.sizeof));

    gdt_set_entry(0, 0, 0, 0, 0); // NULL
    gdt_set_entry(1, 0, 0xffffffff, 0x9a, 0xcf); // K - code
    gdt_set_entry(2, 0, 0xffffffff, 0x93, 0xcf); // K - data
    gdt_set_entry(3, 0, 0xffffffff, 0xfa, 0xcf); // U - code
    gdt_set_entry(4, 0, 0xffffffff, 0xf3, 0xcf); // U - data

    gdt_flush(cast(size_t)&gdt_r);
    set_cr0_pe();
    write("segmentation activated\n", 0);
}

