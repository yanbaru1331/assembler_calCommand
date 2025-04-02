.section .text
.global calendar
.type   calendar %function

@calendar(int y, int m, char *ar);
calendar:
    @r0->年 r1->月 r2->r5 文字列
    @r3 -> 日判定

    cmp     r1, #13
    blge    error
    cmp     r1, #13
    bxge    lr

    cmp     r1, #0
    moveq   r7, #1
    addeq   r1, r1, #1
    
    push    {r2-r10}

LOOP:
    cmp     r7, #1
    pusheq  {r0-r1}

    push    {r3}
    mov     r5, r2
    mov     r2, #1
    mov     r3, r0

    push   {r1-r5,lr}
    bl     zella
    pop    {r1-r5,lr}

    mov     r2, r0
    @r2->曜日 r3->年 r1,r0->月
    @月の日数特定
    mov     r0, r1
    push    {r1-r5, lr}
    mov     r1, r3
    bl      month
    pop    {r1-r5, lr}

    @r0 日数 r2->曜日 r3->年 r1->月

    @　 r0 ->月 r1 ->年 r2 -> 文字列
    push   {r0-r4}
    mov     r0, r1
    mov     r1, r3
    mov     r2, r5
    @1行に年と月の表記
    push    {lr}
    bl      inserthead
    pop     {lr}
    @曜日英語表記
    push    {lr}
    bl      insertDoW
    pop     {lr}
    mov     r5, r0
    pop     {r0-r4}

    @日付の入力
    mov     r4, r0
    @r2->曜日 r3->年 r1->月 r4->日付 r5->文字列
    @insertday r0 文字列 r1 曜日 r2 月の日数 r3 強調日の判定日
    mov     r6, r1
    mov     r0, r5
    mov     r1, r2 @月の日数 -> 0189　3桁目にして12桁に月判定を入れておく
    
    @月＋その月の日数に値を書き換えるところ
    push    {r0, r1, r3-r10, lr}
    mov     r0, r4
    mov     r1, #10
    push    {r6}
    bl      mod
    pop     {r6}
    mov     r4, #10
    mul     r3, r6, r4
    add     r2, r0, r3
    pop     {r0, r1, r3-r10, lr}

    pop     {r3} @指定日
    push    {r1-r10, lr}
    bl      insertday
    pop     {r1-r10, lr}


    cmp     r7, #1
    bne     LOOPEND
    beq     LOOPreplay


LOOPreplay:
    mov     r2, r0
    pop     {r0-r1}
    add     r1, r1, #1
    cmp     r1, #13
    moveq   r0, r2
    beq     LOOPEND
    push    {r1}
    mov     r1, #10
    strb    r1, [r2], #1
    strb    r1, [r2], #1
    pop     {r1}
    bne     LOOP


LOOPEND:
    mov     r1, #0 
    strb    r1, [r0], #1
    pop     {r2-r10}
    bx     lr
