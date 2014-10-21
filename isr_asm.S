%macro ITP_NO_ERRORCODE 1
    [GLOBAL isr_hdl%1u]
    isr_hdl%1u:
        cli ;disable intp
        push byte 0 ;no error code
        push byte %1 ;intp nbr
        jmp isr_code ;jmp to handler code
%endmacro

%macro ITP_ERRORCODE 1
    [GLOBAL isr_hdl%1u]
    isr_hdl%1u:
        cli
        push byte %1
        jmp isr_code
%endmacro

; 0        No
; 1        No
; 2        No
; 3        No
; 4        No
; 5        No
; 6        No
; 7        No
; 8        Yes
; 9        No
; 10       Yes
; 11       Yes
; 12       Yes
; 13       Yes
; 14       Yes
; 15       No
; 16       No
; 17       No
; 18       No
; 19 to 31 No

ITP_NO_ERRORCODE 0
ITP_NO_ERRORCODE 1
ITP_NO_ERRORCODE 2
ITP_NO_ERRORCODE 3
ITP_NO_ERRORCODE 4
ITP_NO_ERRORCODE 5
ITP_NO_ERRORCODE 6
ITP_NO_ERRORCODE 7
ITP_ERRORCODE    8
ITP_NO_ERRORCODE 9
ITP_ERRORCODE    10
ITP_ERRORCODE    11
ITP_ERRORCODE    12
ITP_ERRORCODE    13
ITP_ERRORCODE    14
ITP_NO_ERRORCODE 15
ITP_NO_ERRORCODE 16
ITP_NO_ERRORCODE 17
ITP_NO_ERRORCODE 18
ITP_NO_ERRORCODE 19
ITP_NO_ERRORCODE 20
ITP_NO_ERRORCODE 21
ITP_NO_ERRORCODE 22
ITP_NO_ERRORCODE 23
ITP_NO_ERRORCODE 24
ITP_NO_ERRORCODE 25
ITP_NO_ERRORCODE 26
ITP_NO_ERRORCODE 27
ITP_NO_ERRORCODE 28
ITP_NO_ERRORCODE 29
ITP_NO_ERRORCODE 30
ITP_NO_ERRORCODE 31
ITP_NO_ERRORCODE 128

extern isr_handler

isr_code:
    pusha
    mov ax, ds
    push eax
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call isr_handler

    pop ebx
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx

    popa
    add esp, 8
    sti
    iret

;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;--------------------------IRQs-------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------


%macro IRQ 2
    global irq%1
    irq%1:
        cli
        push byte 0
        push byte %2
        jmp irq_code
%endmacro

IRQ      0,  32
IRQ      1,  33
IRQ      2,  34
IRQ      3,  35
IRQ      4,  36
IRQ      5,  37
IRQ      6,  38
IRQ      7,  39
IRQ      8,  40
IRQ      9,  41
IRQ     10,  42
IRQ     11,  43
IRQ     12,  44
IRQ     13,  45
IRQ     14,  46
IRQ     15,  47

[EXTERN irq_handler]

irq_code:
   pusha

   mov ax, ds
   push eax                 ; save ds

   mov ax, 0x10  ; load the kernel ds descriptor
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax

   call irq_handler

   pop ebx        ; reload the original ds descriptor
   mov ds, bx
   mov es, bx
   mov fs, bx
   mov gs, bx

   popa
   add esp, 8
   sti
   iret
