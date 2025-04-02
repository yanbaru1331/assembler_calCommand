.section .text
.global inserthead
.type   inserthead %function

inserthead:
    @　 r0 ->月 r1 ->年 r2 -> 文字列
    push    {r0}
    mov     r0 ,r1
    mov     r4, r2
    b       loopyear 
date:   
    pop     {r0}
    b       loopdate
    
@年処理
loopyear:
    mov     r2, #35
    mov     r5, r2
    mov     r1, #10
    push    {r2}
    b       PDL1

loopdate:
    mov     r2, #36
    mov     r5, r2
    mov     r1, #10
    push    {r2}
    b       PDL1

PDL1:   
    mov     r3, #0
PDL2:
    cmp     r0, r1
    blt     PDL2OUT
    sub     r0, r0, r1
    add     r3, r3, #1
    b       PDL2
PDL2OUT:
    mov     r2, r0
    push    {r2}
    mov     r0, r3
    cmp     r0, #0
    ble     PDL1OUT
    b       PDL1
PDL1OUT:

PDL3:
    pop     {r2}
    cmp     r2, r5
    beq     PDL3OUT
    add     r0, r2, #48
    push    {r0-r3, r5, lr}
    mov     r1, r0
    mov     r0, r4
    bl      insert
    mov     r4, r0
    pop     {r0-r3, r5, lr}
    b       PDL3

PDL3OUT:
    cmp     r5, #35
    beq     insertspace
    mov     r0, r4
    bne     loopend


insertspace:
    push    {r0-r3, lr}
    mov     r0, r4
    mov     r1, #32
    mov     r2, #0
    push    {lr}
    bl      insert
    pop     {lr}
    mov     r4, r0
    pop     {r0-r3, lr}
    b       date


loopend:
    mov     r1, #10
    push    {lr}
    bl      insert
    pop     {lr}
    bx      lr
    