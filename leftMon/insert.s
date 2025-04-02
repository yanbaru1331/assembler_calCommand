.section .text
.global insert
.type   insert %function

@insert r0 char[], 挿入する文字

insert:
    strb    r1, [r0], #1
    bx      lr

