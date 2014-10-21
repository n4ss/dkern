[GLOBAL idt_flush]

idt_flush:
;load idtr
    mov eax, [esp+4]
    lidt [eax]
    ret
