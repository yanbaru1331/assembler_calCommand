.section .text
.global insertday
.type   insertday %function
@insertday r0 文字列 r1 曜日 r2 月と月の日数 

insertday:
    push    {r1-r10}
    mov     r8, r3      @未使用レジスタ退避
    push    {r8}
    mov     r3, r2
    push    {r3}        @月の日数の退避
@r0文字列 r1 初めの日(曜日)
    mov     r3, r1      @r012は挿入で使うので退避
    mov     r4, #0      @r4 -> 挿入場所の指定
    mov     r5, #0      @r5 -> １週間を数える
    mov     r6, #0      @r6 -> 3マスを数える
    mov     r1, #32     @r1 ->スペース(アスキー32)

@曜日が日曜なら終わり
    cmp     r3, #0
    beq     emptyDayEnd

emptyDay:
    push    {r1-r10, lr}
    bl      insert
    pop     {r1-r10, lr}

    add     r6, r6, #1
    cmp     r6, #3
    moveq   r6, #0
    addeq   r5, r5, #1
    cmp     r3, r5
    beq     emptyDayEnd
    b       emptyDay

emptyDayEnd:

    @r2 ->挿入場所の指定
    @r012は挿入で使うので退避
    @r4 -> 挿入場所の指定
    @r5 -> １週間を数える
    @r6 -> 3マスを数える
    @r7 -> 日付カウント
    @r1 ->スペース(アスキー32)
    @r3 -> 初めに積んだ月の日数
    mov     r7, #1
    
    pop     {r3}
    push    {r0-r2, r5-r10, lr}
    mov     r4, r3
    push    {r4}

    @日付判断部
    push    {r3, lr}
    mov     r0, r3
    mov     r1, #10
    bl      mod
    pop     {r3, lr}
    cmp     r0, #0
    moveq   r3, #30
    cmp     r0, #1
    moveq   r3, #31
    cmp     r0, #8
    moveq   r3, #28
    cmp     r0, #9
    moveq   r3, #29

    @月判断部
    pop     {r4}
    push    {r3, lr}
    mov     r0, r4
    mov     r1, #10
    bl      div
    pop     {r3, lr}
    mov     r4, r0
    pop    {r0-r2, r5-r10, lr}
    pop     {r8}
  
@ここまではOK
@r4 月 r3 日数
date:
    @日付がその月の日付を超えてないか確認
    cmp     r7, r3
    bhi     insertEnd

    @初日が日曜である場合の処理
    cmp     r7, #1
    cmpeq   r5, #0
    beq     newlineskip       
    
    @\nの確認
    push    {r0-r4, r6-r10, lr}
    mov     r0, r5
    mov     r1, #7
    bl      mod
    cmp     r0, #0
    mov     r5, r0
    pop     {r0-r4, r6-r10, lr}
    
    @改行挿入
    pusheq  {r1-r10, lr}
    bleq     newline
    popeq   {r1-r10, lr}

newlineskip:
    push    {lr}
    bl      insertHoliday
    pop     {lr}

    add     r5, r5, #1
    b       date

weekday:

    @2桁の判断
    push    {r0}
    mov     r0 ,r7
    push    {r0-r9, lr}
    mov     r1, #10
    bl      div
    mov     r10, r0
    cmp     r0, #0
    pop     {r0-r9, lr}
    pop     {r0}
    beq     aDigit
    bne     twoDigit


@1桁の日
aDigit:
    mov     r1, #32


@スペース挿入
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}

    @強調日表記
    cmp     r7, r8
    moveq   r6, #1
    pusheq  {r1-r9,lr}
    bleq    highLightInsert
    popeq   {r1-r9,lr}

    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}


    @数字挿入
    add     r1, r1, #16
    add     r1, r1, r7
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}
    add     r7, r7, #1
    
    @強調表記終わり
    cmp     r6, #1
    moveq   r6, #0
    pusheq  {r1-r9,lr}
    bleq    highLightEnd
    popeq   {r1-r9,lr}
    bx      lr

twoDigit:
    mov     r1, #32
    
    
    @スペース挿入
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}

    @強調日表記

    cmp     r7, r8
    moveq   r6, #1
    pusheq  {r1-r9,lr}
    bleq    highLightInsert
    popeq   {r1-r9,lr}

    @2桁目挿入
    mov     r1, #48
    add     r1, r1, r10
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}

    @1桁目数字挿入
    push    {r0-r9, lr}
    mov     r0, r7
    mov     r1, #10
    bl      mod
    mov     r10, r0
    pop    {r0-r9, lr}
    add     r1, r10, #48
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}
    add     r7, r7, #1

    @強調表記終わり
    cmp     r6, #1
    moveq   r6, #0
    pusheq  {r1-r9,lr}
    bleq    highLightEnd
    popeq   {r1-r9,lr}
    bx      lr  

Holiday:
    push  {r1-r9,lr}
    bl    highLightHoliday
    pop   {r1-r9,lr}

    @2桁の判断
    push    {r0}
    mov     r0 ,r7
    push    {r0-r9, lr}
    mov     r1, #10
    bl      div
    mov     r10, r0
    cmp     r0, #0
    pop     {r0-r9, lr}
    pop     {r0}
    beq     HolidayaDigit
    bne     HolidaytwoDigit


@1桁の日
HolidayaDigit:
    mov     r1, #32


@スペース挿入
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}

    @強調日表記
    cmp     r7, r8
    moveq   r6, #1
    pusheq  {r1-r9,lr}
    bleq    highLightInsert
    popeq   {r1-r9,lr}

    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}

    @数字挿入
    add     r1, r1, #16
    add     r1, r1, r7
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}
    add     r7, r7, #1
    
    @強調表記終わり
    cmp     r6, #1
    moveq   r6, #0
    push  {r1-r9,lr}
    bl    highLightEnd
    pop   {r1-r9,lr}
    cmp     r4, r4
    bx      lr

HolidaytwoDigit:
    mov     r1, #32

    @スペース挿入
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}
    

    @強調日表記
    cmp     r7, r8
    moveq   r6, #1
    pusheq  {r1-r9,lr}
    bleq    highLightInsert
    popeq   {r1-r9,lr}

    @2桁目挿入
    mov     r1, #48
    add     r1, r1, r10
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}

    @1桁目数字挿入
    push    {r0-r9, lr}
    mov     r0, r7
    mov     r1, #10
    bl      mod
    mov     r10, r0
    pop    {r0-r9, lr}
    add     r1, r10, #48
    push    {r1-r9,lr}
    bl      insert
    pop     {r1-r9,lr}
    add     r7, r7, #1

    cmp     r6, #1
    moveq   r6, #0
    push  {r1-r9,lr}
    bl    highLightEnd
    pop   {r1-r9,lr}
    cmp     r4, r4
    bx      lr  


@祝祭日の判定と挿入をする関数
@まとめて祝祭日なら下違うなら上の処理に戻るように考える
insertHoliday:
    @r0 文字列 r1 日 r2 月

    cmp     r4, #1
    pusheq  {lr}
    bleq     Jan
    popeq  {lr}
    
    cmp     r4, #2
    pusheq  {lr}
    bleq     Feb
    popeq  {lr}
    
    cmp     r4, #3
    pusheq  {lr}
    bleq     Mar
    popeq  {lr}
    
    cmp     r4, #4
    pusheq  {lr}
    bleq     Apr
    popeq  {lr}
    
    cmp     r4, #5
    pusheq  {lr}
    bleq     May
    popeq  {lr}

    cmp     r4, #6
    pusheq  {lr}
    bleq     Jun
    popeq  {lr}

    cmp     r4, #7
    pusheq  {lr}
    bleq     Jul
    popeq  {lr}

    cmp     r4, #8
    pusheq  {lr}
    bleq     Aug
    popeq  {lr}
    
    cmp     r4, #9
    pusheq  {lr}
    bleq     Sep
    popeq  {lr}
    
    cmp     r4, #10
    pusheq  {lr}
    bleq     Oct
    popeq  {lr}
    
    cmp     r4, #11
    pusheq  {lr}    
    bleq     Nov
    popeq  {lr}
    
    cmp     r4, #12
    pusheq  {lr}    
    bleq    Dec
    popeq  {lr}
    
    
    bx    lr 

Jan:
    cmp     r7, #1
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     janend

    push    {r8}
    mov     r8, #14
    cmp     r7, #8
    cmpge   r8, r7 
    cmpge   r5, #1
    pop     {r8}
    pusheq  {lr}
    bleq    Holiday

    popeq   {lr}
    beq     janend
    
    push  {lr}
    bl    weekday
    pop   {lr}
janend:
    cmp     r4, r4
    bx      lr

Feb:
    cmp     r7, #11
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     febend

    cmp     r7, #23
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     febend

    push    {lr}
    bl      weekday
    pop     {lr}

febend:
    cmp     r4, r4
    bx      lr

Mar:
    cmp     r7, #21
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     marend

    push    {lr}
    bl      weekday
    pop     {lr}
    beq     marend

marend:
    cmp     r4, r4
    bx      lr

Apr:
    cmp     r7, #29
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     aprend  

    push    {lr}
    bl      weekday      
    pop     {lr}
    beq     aprend

aprend:
    cmp     r4, r4
    bx      lr

May:
    cmp     r7, #3
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     mayend

    cmp     r7, #4
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     mayend

    cmp     r7, #5
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     mayend


    push    {lr}
    bl      weekday
    pop     {lr}

mayend:
    cmp     r4, r4
    bx      lr

Jul:
    push    {r8}
    mov     r8, #21
    cmp     r7, #15
    cmpge   r8, r7 
    cmpge   r5, #1
    pop     {r8}
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     julend


    push    {lr}
    bl      weekday
    pop     {lr}
    beq     julend

julend:
    cmp     r4, r4
    bx      lr
   
Aug:
    cmp     r7, #11
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     augend

    push    {lr}
    bl      weekday
    pop     {lr}
    beq     augend

augend:
    cmp     r4, r4
    bx      lr

Sep:
    push    {r8}
    mov     r8, #21
    cmp     r7, #15
    cmpge   r8, r7 
    cmpge   r5, #1
    pop     {r8}
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     sepend

    cmp     r7, #23
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     sepend

    push    {lr}
    bl      weekday
    pop     {lr}

sepend:
    cmp     r4, r4
    bx      lr

Oct:
    push    {r8}
    mov     r8, #14
    cmp     r7, #8
    cmpge   r8, r7 
    cmpge   r5, #1
    pop     {r8}
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}

    beq     octend

    push    {lr}
    bl      weekday
    pop     {lr}

octend:
    cmp     r4, r4
    bx      lr

Nov:
    cmp     r7, #3
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     novend

    cmp     r7, #23
    pusheq  {lr}
    bleq    Holiday
    popeq   {lr}
    beq     novend

    push    {lr}
    bl      weekday
    pop     {lr}

novend:
    cmp     r4, r4
    bx      lr

Jun:
Dec:
    push    {lr}
    bl      weekday
    pop     {lr}
    cmp     r4, r4
decend:
    cmp     r4, r4
    bx      lr



insertEnd:
@\0を入れる部分
    push    {r1-r10, lr}
    @mov     r1, #0
    @bl      insert
    pop     {r1-r10, lr}
    pop     {r1-r10}
    bx      lr

.section .text
.global newline
.type   newline %function
newline:
    mov     r1, #10
    push    {r1-r10, lr}
    bl      insert
    pop     {r1-r10, lr}
    bx      lr
