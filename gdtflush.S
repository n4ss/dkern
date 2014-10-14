[GLOBAL gdt_flush]

gdt_flush:
;load gdtr
    mov eax, [esp+4]
    lgdt [eax]

; reload segments
    mov ax, 0x10
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    ;set cs and return
    jmp 0x08:.flushing
.flushing:
    ret

[GLOBAL set_cr0_pe]

; set protected mode
set_cr0_pe:
    mov eax, cr0
    or al, 0x1
    mov cr0, eax
    ret
