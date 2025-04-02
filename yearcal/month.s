.section .text
.global month
.type   month %function

month:
    cmp     r0, #2
    beq     leapfunc
    cmp     r0, #4
    beq     thirty
    cmp     r0, #6
    beq     thirty
    cmp     r0, #9
    beq     thirty
    cmp     r0, #11
    beq     thirty
    bne     thirtyOne

leapfunc:
    push    {lr}
    mov     r0, r1
    bl      leap
    pop     {lr}
    bx      lr

thirtyOne:
    mov     r0, #31
    bx      lr

thirty:
    mov     r0, #30
    bx      lr
