module kernel.main;

import console;
import utils;
import gdt;
import idt;

enum int test_index = 10u;

extern(C) extern __gshared void *_data_end;
static __gshared void *brk = &_data_end;

extern(D) auto malloc(T)(size_t size) {
    void *res = brk;
    brk = (cast(char *)brk + size);

    return cast(T)res;
}

extern(D) void free(void *loltarace) {}

extern(D) auto realloc(T)(void *ptr, size_t size) {
    if (!ptr)
        return malloc!(T)(res);
    if (!size && ptr)
        return null;

    malloc!(T)(res);
    memcpy!(T)(res, ptr, size);
    return res;
}

extern(D) auto strlen(T)(T s) {
    auto i = 0;

    for (; *s; ++s)
        ++i;

    return i;
}

extern(C) void memcpy(T)(T dest, T src, size_t size) {
    ubyte *tdest = cast(ubyte *)dest;
    ubyte *tsrc = cast(ubyte *)src;
    for (size_t i = 0; i < size; ++i)
        tdest[i] = tsrc[i];
}

extern(C) void memset(T)(T dest, ubyte c, size_t size) {
    ubyte *tdest = cast(ubyte *)dest;
    for (size_t i = 0; i < size; ++i)
        tdest[i] = c;
}

extern(C) void _D15TypeInfo_Struct6__vtblZ() {}
extern(C) void _D11TypeInfo_Aa6__initZ() {}
extern(C) void _D12TypeInfo_Aya6__initZ() {}

// FIXME
extern(C) void *_adDupT() {return null;}

extern(D) char[] _d_arraycatT(void *ti, char s1[],char s2[]) {
//    uint size1 = strlen!(char *)(cast(char *)s1);
//    uint size2 = strlen!(char *)(cast(char *)s2);

    char *ptr = malloc!(char *)(s1.length + s2.length + 1);
    if (ptr) {
        memcpy!(char *)(ptr, s1.ptr, s1.length);
        memcpy!(char *)(ptr + s1.length, s2.ptr, s2.length);
        ptr[s1.length + s2.length + 1] = '\0';
        return ptr[0 .. s1.length + s2.length];
    }


    void *r = malloc!(void *)(size_t.sizeof * 2);

    (cast(size_t *)r)[0] = s1.length + s2.length;
    (cast(size_t *)r)[1] = cast(size_t)ptr;

    return cast(char[])*cast(char[] *)&r;
}

extern(C) void *_Dmodule_ref() { return null;}

void test_concat() {
    /* Concatenate strings */
    string lol1 = "1lolok1";
    string lol2 = "2lolok2\n";
    string lol3 = lol1 ~ lol2;
    write(cast(char *)lol3.ptr, lol3.length);

    string s = test_index.stringof;
    write(s.ptr, s.length);
}

void test_idt() {
    /* Division by zero: test IDT */
    uint i = 3;
    uint x = 0;
    uint v = i / x;
}

extern(C) void main(uint magic, uint addr) {
    clear();
    write("Console initialized\n", 20);
    init_gdt();
    init_idt();

//    test_concat();
//    test_idt();

    while (1) {
    }
}
