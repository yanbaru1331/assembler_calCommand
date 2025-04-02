.section .text
.global div
.type   div %function
@割り算関数部分->r0,割られる数 r1->割る数　出力r0->割り算の商

div:
    mov r2, r1
    mov r1, r0
    mov r0, #0
 
loop:
    cmp r1, r2
    blt loopout
    add r0, r0, #1
    sub r1, r1, r2
    b loop

loopout:
    bx lr
    