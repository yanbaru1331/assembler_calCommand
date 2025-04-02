.section .text
.global leap
.type   leap %function

leap:
    @閏年処理
    @mod25
    @r0 ->年 一度r5に退避
    push    {r1-r5,lr}
    mov     r5, r0
    mov     r1, #25
    push    {r1-r5, lr}
    bl      mod
    pop    {r1-r5, lr}
    cmp     r0, #0
    moveq   r3, #1
    @等しくなかった時の#0代入   
    movne   r3, #0

leap1:
    @mod16
    mov     r0, r5
    and     r0, r0, #15
    
    @mod16=0なら0以外なら1を入れる
    cmp     r0, #0
    moveq   r4, #1
    beq     leapend
    movne   r4, #0
    
    @mod 4
    mov     r1, #4
    push    {r2-r5, lr}
    bl      mod
    pop     {r2-r5, lr}
    
    cmp     r0, #0
    @mod4 =0なら1以外なら一致回避のため123を入れる
    moveq   r5, #1
    beq     leapend
    movne   r5, #0

leapend:
    @mod25 && mod 16
    cmp     r3, r4
    cmpeq   r3, #1
    beq     leapyear
    @mod25 && mod 4
    cmp     r5, r3
    cmpeq   r5, #1
    beq     nonleap
    @mod4 == 1 
    cmp     r5, #1
    beq     leapyear
    b       nonleap

leapyear:
    mov    r0, #29
    pop    {r1-r5,lr}
    bx      lr

nonleap:
    mov     r0, #28
    pop    {r1-r5,lr}
    bx      lr
