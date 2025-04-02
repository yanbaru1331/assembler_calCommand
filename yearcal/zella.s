.section .text
.global zella
.type   zella %function

zella:
    push    {r3, r4, r5, r6, r7, r8}
    
    @1月2月の処理(前年13,14月として処理)
    cmp     r1, #1
    addeq   r1, r1, #12
    subeq   r0, r0, #1
    cmp     r1, #2
    addeq   r1, #12
    subeq   r0, r0, #1

    @monthの計算
    mov     r8, r2
    mov     r4, #13
    mul     r1, r1, r4
    add     r1, r1, #8
    mov     r3, r0
    mov     r0, r1
    mov     r1, #5

    @monthの割り算
    push    {lr}
    bl      div
    pop     {lr}
    mov     r7, r0

    @y/4
    mov     r0, r3
    mov     r1, #4
    push    {lr}
    bl      div
    pop     {lr}
    mov     r6, r0

    @y/100
    mov     r0, r3
    mov     r1, #100
    push    {lr}
    bl      div
    pop     {lr}
    mov     r5, r0

    @y/400
    mov     r0, r3
    mov     r1, #400
    push    {lr}
    bl      div
    pop     {lr}   
    mov     r4, r0

    @計算したものを全て足す処理
    add     r0, r3, r6
    add     r0, r0, r4
    add     r0, r0, r7
    add     r0, r0, r8
    sub     r0, r0, r5
    mov     r8, r0
    
    @足したもののmod7を求める
    push    {r8,lr}
    mov     r1, #7
    bl      mod
    pop     {r8,lr}
    pop     {r3, r4, r5, r6, r7, r8}
    bx lr



