module runtime;

extern(C) void onArrayBoundsError(char[] file, uint line)
{
    // FIXME: error msg
}

extern(C) void _d_arraybounds(char[] file, uint line) {
    onArrayBoundsError(file, line);
}
