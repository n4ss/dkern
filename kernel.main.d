module kernel.main;

import utils;
import gdt;

extern(C) void main(uint magic, uint addr) {
    int ypos = 0;
    int xpos = 0;
    const uint COLUMNS = 80;
    const uint LINES = 25;


    ubyte* vidmem = cast(ubyte*)0xFFFF8000000B8000; //Video memory address
    mixin("xpos = 20;");

    for (int i = 0; i < COLUMNS * LINES * 2; i++) {
            *(vidmem + i) = 0x0;
    }

    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = 'T' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = 'E' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = 'S' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = 'T' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = ' ' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = ' ' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = '1' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = '2' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = '3' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = ' ' & 0xFF;
    *(vidmem + (xpos + ypos * COLUMNS) * 2 + 1) = 0x07;
    *(vidmem + (xpos++ + ypos * COLUMNS) * 2) = '!' & 0xFF;

    init_gdt();

    while (1) {
    }
}

extern(C) void _D15TypeInfo_Struct6__vtblZ() {}
extern(C) void *_Dmodule_ref() { return null;}
