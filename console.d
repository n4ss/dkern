module console;

enum ubyte CONS_ESCAPE   = 255;
enum ubyte CONS_CLEAR    = 1;
enum ubyte CONS_COLOR    = 2;
enum ubyte CONS_SETX     = 3;
enum ubyte CONS_SETY     = 4;
enum ubyte CONS_BLACK    = 0;
enum ubyte CONS_BLUE     = 1;
enum ubyte CONS_GREEN    = 2;
enum ubyte CONS_CYAN     = 3;
enum ubyte CONS_RED      = 4;
enum ubyte CONS_MAGENTA  = 5;
enum ubyte CONS_YELLOW   = 6;
enum ubyte CONS_WHITE    = 7;
enum ubyte CONS_BLINK    = (1 << 7);
enum ubyte CONS_LIGHT    = (1 << 3);


enum ushort *mem = cast(ushort *)0xb8000;

__gshared ubyte cursor_x = 0;
__gshared ubyte cursor_y = 0;
__gshared ubyte attr = 0;

__gshared ubyte CONS_FRONT(ubyte color) { return color; }
__gshared ubyte CONS_BACK(ubyte color) { return cast(ubyte)(color << 4); }


extern(C) void outb(ushort port, ubyte value) {
    asm {
        "outb %1, %0" :: "dN" (port), "a" (value) ;
    }
}

extern(C) ubyte inb(ushort port) {
    ubyte value;
    asm {
        "inb %1, %0" : "=a" (value) : "dN" (port) ;
    }
    return value;
}

extern(D) void update_cursor() {
    ushort cursor_loc = cursor_y * 80 + cursor_x;

    outb(cast(ushort)0x3D4, cast(ubyte)14);
    outb(cast(ushort)0x3D5, cast(ubyte)(cursor_loc  >> 8));

    outb(cast(ushort)0x3D4, cast(ubyte)15);
    outb(cast(ushort)0x3D5, cast(ubyte)cursor_loc);
}

extern(D) void clear() {
    attr = CONS_FRONT(CONS_WHITE) | CONS_BACK(CONS_BLACK);

    int i = 0;
    for(;i<80*25;i++)
        mem[i] = 0x20  | (attr  <<  8);

    cursor_x = 0;
    cursor_y = 0;
    update_cursor();

}

extern(D) void scroll() {
    attr = CONS_FRONT(CONS_WHITE) | CONS_BACK(CONS_BLACK);
    ushort blank = 0x20 | (attr  << 8);

    if (cursor_y >= 25)
    {
        int i = 0;
        for(; i < 24*80; i++)
            mem[i] = mem[i+80];
        for(i = 24*80; i < 25*80; i++)
            mem[i] = blank;

        cursor_y = 24;
    }
}

extern(D) void set_attr(ubyte color) {
    attr = CONS_FRONT(color) | CONS_BACK(CONS_BLACK);
}

extern(D) void putc(char c) {
    attr = CONS_FRONT(CONS_WHITE) | CONS_BACK(CONS_BLACK);
    ushort *loc;
    ushort attribute = attr << 8;

    if(c == 0x08 && cursor_x) {
        cursor_x--;
        loc = mem + (cursor_y*80 + cursor_x);
        *loc = 0 | attribute;
    }
    else if(c == '\r') {
        cursor_x = 0;
    }
    else if(c == '\n') {
        cursor_x = 0;
        cursor_y++;
    }
    else if(c == '\t') {
        cursor_x = cast(ubyte)(cursor_x + 8) & ~7;
    }
    else if(c >= ' ') {
        loc = mem + (cursor_y*80 + cursor_x);
        *loc = c | attribute;
        cursor_x++;
    }

    if(cursor_x >= 80) {
        cursor_x = 0;
        cursor_y++;
    }

    scroll();
    update_cursor();
}

extern(D) int write(const char *s, int length)
{
    int i = 0;
    while(s[i] && i < length) {
        putc(s[i++]);
    }
    putc('\0');

    return i;
}

extern(D) int write_dec(uint n)
{
    if(n==0)
    {
        putc('0');
        return 0;
    }

    int rest = n;
    char str[32];
    int i = 0;
    int j = 0;

    while(rest > 0)
    {
        str[i] = '0' + rest%10;
        rest /= 10;
        i++;
    }

    str[i] = 0;

    char str2[32];
    str2[i--] = 0;

    while(i >= 0)
        str2[i--] = str[j++];

    write(cast(const char*)str2, 0);
    return 0;
}

int write_hex(uint n)
{
    int tmp;
    write("0x",2);
    char nozero = 1;
    int i;
    for(i = 28; i>0; i -= 4)
    {
        tmp = (n >> i) & 0xf;
        if(tmp == 0 && nozero != 0)
            continue;
        if(tmp >= 0xa) {
            nozero = 0;
            putc(cast(ubyte)(tmp - 0xA + 'a'));
        } else {
            nozero = 0;
            putc(cast(char)(tmp + '0'));
        }
    }
    tmp = n & 0xf;
    if(tmp >= 0xA) {
        putc(cast(ubyte)(tmp - 0xA+'a'));
    } else {
        putc(cast(ubyte)(tmp + '0'));
    }
    return 0;
}

