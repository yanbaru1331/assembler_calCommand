.section .text
.global highLightInsert
.type   highLightInsert %function

@insert r0 char[], 挿入する文字

highLightInsert:
    ldr     r2, =highlightStert
highLightInsertLoop:
    ldrb    r1, [r2], #1
    cmp     r1, #97
    beq     insertend
    strb    r1, [r0], #1
    b       highLightInsertLoop

insertend:
    bx      lr

.section .text
.global highLightEnd
.type   highLightEnd %function

highLightEnd:
    ldr     r2, =highlightEnd
highLightEndLoop:
    ldrb    r1, [r2], #1
    cmp     r1, #99
    beq     end
    strb    r1, [r0], #1
    b       highLightEndLoop

end:
    bx      lr

.section    .text
.global highLightHoliday
.type   highLightHoliday %function

highLightHoliday:
    ldr     r2, =highlightHoliday
highLightHolidayloop:
    ldrb    r1, [r2], #1
    cmp     r1, #100
    beq     highLightHolidayend
    strb    r1, [r0], #1
    b       highLightHolidayloop

highLightHolidayend:
    bx      lr
.section .data
highlightStert:
    .asciz  "\x1b[47ma"

.section .data
highlightEnd:
    .asciz  "\x1b[0mc"

.section .data
highlightHoliday:
    .asciz  "\x1b[31md"
