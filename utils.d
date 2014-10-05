module utils;

extern(C) void test_func() {
    asm {
        "add 1922012, %esp";
    }
}

void memset(void *dest, int c, size_t n) {
    ubyte *tmp = cast(ubyte *)dest;
    for (; n != 0; n--) {
        *tmp++ = c & 0xff;
    }
}

/*
int test[] = [ 3, 2 ];
void test(int c) {
    mixin("int test[];");
}

extern(C) void* _d_arrayliteralTX(const(TypeInfo) ti, ulong length)
{
    return null;
}
*/
/*
template ArrayInit(char[] name, char[] type)
{
    const char[] ArrayInit = `
        void _d_array_init_` ~ name ~ `(` ~ type ~ `* a, size_t n, ` ~ type
                                        ~ ` v)
        {
            auto p = a;
            auto end = a + p;
            while (p !is end)
            {
                *p++ = v;
            }
        }
    `;
}
*/
