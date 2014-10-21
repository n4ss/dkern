module isr;

import console;

struct registers {
    align(1):
    uint ds;
    uint edi;
    uint esi;
    uint ebp;
    uint esp;
    uint ebx;
    uint edx;
    uint ecx;
    uint eax;
    uint int_no;
    uint err_code;
    uint eip;
    uint cs;
    uint eflags;
    uint useresp;
    uint ss;
}

alias void function(registers*) t_isr;

extern(C) __gshared t_isr itp_handler[256];

extern(C) extern __gshared void isr_handler(registers regs) {
    uint int_no = regs.int_no & 0xff;
    if (itp_handler[int_no]) {
        itp_handler[int_no](&regs);
    } else {
        string s = "Unhandled interrupt: ";
        write(s.ptr, s.length);
        write_hex(int_no);
        while(1) {}
    }
}

extern(C) void register_int_hdl(uint nbr, t_isr hdl) {
    itp_handler[nbr] = hdl;
}

extern(C) void irq_handler(registers regs) {
    if (regs.int_no >= 40) 
        outb(0xa0, 0x20);
    outb(0x20, 0x20);

    if (itp_handler[regs.int_no]) {
        itp_handler[regs.int_no](&regs);
    }
}
