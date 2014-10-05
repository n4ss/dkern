module gdt;

import utils;

struct GdtPtr {
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

GdtEntry gdt_entries[6];
GdtPtr gdt_r;

void gdt_new_entry(uint index, uint base, uint limit,
                   ubyte access, ubyte gran) {
    gdt_entries[index].limit = limit & 0xffff;

    gdt_entries[index].base_l = base & 0xffff;
    gdt_entries[index].base_m = (base >> 16) & 0xff;
    gdt_entries[index].base_h = (base >> 24) & 0xff;

    gdt_entries[index].gran = (limit >> 16) & 0x0f;
    gdt_entries[index].gran |= gran & 0xf0;
}

void init_gdt() {
    memset(cast(void *)gdt_entries, 0, 6 * (GdtEntry.sizeof));
}

