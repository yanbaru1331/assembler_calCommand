.section .text
.global insertDoW
.type   insertDoW %function

insertDoW:
@r0 -> 文字列 r1 -> 挿入文字 r2 -> 3文字カウンタ　r3 -> 週間カウンタ
    mov     r2, #0
    mov     r3, #0
    mov     r4, #0
    ldr     r5, =datebuf
    push    {r1-r5, lr}
    mov     r1, #32
    bl      insert
    pop     {r1-r5, lr}

loop1:
    cmp     r2, #2
    beq     loop1end
    ldrb    r1, [r5, r3]
    push    {r1-r5, lr}
    bl      insert
    pop     {r1-r5, lr}
    add     r2, r2, #1
    add     r3, r3, #1 
    b       loop1

loop1end:
    @cmp     r5, #97
    cmp     r4, #6
    beq     end
    add     r4, r4, #1
    mov     r2, #0
    push    {r1-r5, lr}
    mov     r1, #32
    bl      insert
    pop     {r1-r5, lr}
    b       loop1


end:
    push    {r1-r5, lr}
    mov     r1, #10
    bl      insert
    pop     {r1-r5, lr}
    bx      lr


.section .data
datebuf:
    .asciz "SuMoTuWeThFrSa"
