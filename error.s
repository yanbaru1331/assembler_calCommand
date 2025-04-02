.section .text
.global error
.type   error %function

error:
    push    {r1-r5, lr}
    ldr     r2, =errorMessageHilight
errorHilightLoop:
    ldrb    r1, [r2], #1
    cmp     r1, #100
    beq     errorHilightend
    strb    r1, [r0], #1
    b       errorHilightLoop

errorHilightend:
    ldr     r2, =errorMessage
errorLoop:
    ldrb    r1, [r2], #1
    cmp     r1, #97
    beq     errorend
    strb    r1, [r0], #1
    b       errorLoop

errorend:
    push    {r1-r5, lr}
    bl      highLightEnd
    pop     {r1-r5, lr}
    mov     r1, #0
    strb    r1, [r0], #1
    pop     {r1-r5, lr}
    bx      lr

.section .data
errorMessageHilight:
    .asciz  "\x1b[31md"

.section .data
errorMessage:
    .asciz  "error!!!!a"
