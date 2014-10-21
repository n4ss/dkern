module idt;

import console;
import utils;

enum IDT_NBENTRIES = 256;

struct IdtPtr {
    align (1):
    ushort limit;
    uint base;
}

struct IdtEntry {
    align(1):
    ushort  offset_l;
    ushort  seg_sel;
    ubyte   zero;
    ubyte   flags;
    ushort  offset_h;
}

extern(C) extern __gshared void isr_hdl0u();
extern(C) extern __gshared void isr_hdl1u();
extern(C) extern __gshared void isr_hdl2u();
extern(C) extern __gshared void isr_hdl3u();
extern(C) extern __gshared void isr_hdl4u();
extern(C) extern __gshared void isr_hdl5u();
extern(C) extern __gshared void isr_hdl6u();
extern(C) extern __gshared void isr_hdl7u();
extern(C) extern __gshared void isr_hdl8u();
extern(C) extern __gshared void isr_hdl9u();
extern(C) extern __gshared void isr_hdl10u();
extern(C) extern __gshared void isr_hdl11u();
extern(C) extern __gshared void isr_hdl12u();
extern(C) extern __gshared void isr_hdl13u();
extern(C) extern __gshared void isr_hdl14u();
extern(C) extern __gshared void isr_hdl15u();
extern(C) extern __gshared void isr_hdl16u();
extern(C) extern __gshared void isr_hdl17u();
extern(C) extern __gshared void isr_hdl18u();
extern(C) extern __gshared void isr_hdl19u();
extern(C) extern __gshared void isr_hdl20u();
extern(C) extern __gshared void isr_hdl21u();
extern(C) extern __gshared void isr_hdl22u();
extern(C) extern __gshared void isr_hdl23u();
extern(C) extern __gshared void isr_hdl24u();
extern(C) extern __gshared void isr_hdl25u();
extern(C) extern __gshared void isr_hdl26u();
extern(C) extern __gshared void isr_hdl27u();
extern(C) extern __gshared void isr_hdl28u();
extern(C) extern __gshared void isr_hdl29u();
extern(C) extern __gshared void isr_hdl30u();
extern(C) extern __gshared void isr_hdl31u();

extern(C) extern __gshared void isr_hdl128u();

extern(C) extern void irq_hdl0u();
extern(C) extern void irq_hdl1u();
extern(C) extern void irq_hdl2u();
extern(C) extern void irq_hdl3u();
extern(C) extern void irq_hdl4u();
extern(C) extern void irq_hdl5u();
extern(C) extern void irq_hdl6u();
extern(C) extern void irq_hdl7u();
extern(C) extern void irq_hdl8u();
extern(C) extern void irq_hdl9u();
extern(C) extern void irq_hdl10u();
extern(C) extern void irq_hdl11u();
extern(C) extern void irq_hdl12u();
extern(C) extern void irq_hdl13u();
extern(C) extern void irq_hdl14u();
extern(C) extern void irq_hdl15u();

__gshared IdtEntry idt_entries[IDT_NBENTRIES];
__gshared IdtPtr idt_r;

extern(C) void idt_flush(uint gdtr);

extern(D) void idt_set_entry(uint index, uint offset, ushort seg_sel, ubyte flags) {
    idt_entries[index].offset_l = offset & 0xffff;
    idt_entries[index].offset_h = (offset >> 16) & 0xffff;
    idt_entries[index].seg_sel = seg_sel;
    idt_entries[index].flags = flags;
    idt_entries[index].zero = 0;
}

/* A simple recursive template which will result in a char[] setting each entry
** of the IDT from 0 to 31, let’s just mixin() this sh?#!t
*/
template generate_idt(uint nb_entries, uint index = 0) {
    static if (nb_entries == index) {
        const char generate_idt[] = `idt_set_entry(128,
                                                   cast(size_t)&isr_hdl128u,
                                                   0x08, 0x8e);
            `;
    }
    else {
        const char generate_idt[]= `
            idt_set_entry( ` ~
                           index.stringof ~ `, ` ~
                           `cast(size_t)&isr_hdl` ~ index.stringof ~ `, ` ~
                           `0x08, 0x8e);
        ` ~ generate_idt!(nb_entries, index + 1);
    }
}


extern(D) void init_idt() {
    idt_r.limit = (IdtEntry.sizeof * IDT_NBENTRIES) - 1;
    idt_r.base = cast(size_t)idt_entries.ptr;
    memset(cast(void *)idt_entries, 0, IDT_NBENTRIES * (IdtEntry.sizeof));

    mixin(generate_idt!(31));
    //const char []test_string = generate_idt!(3);
    //write(test_string.ptr, test_string.length);

    idt_flush(cast(size_t)&idt_r);
    write("Interrupts handled\n", 19);
}
