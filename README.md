# assembler_calCommand

arm v4用カレンダー

```
gcc calendar.c calendar.s div.s insert.s insertDoW.s insertday.s inserthead.s mod.s month.s leap.s zeller.s insertHighLight.s
```
でビルドして
```
/*
root@fdbbee098cb5:~# ./a.out 2022 12
y =2022 m = 12
              1  2  3
  4  5  6  7  8  9 10
 11 12 13 14 15 16 17
 18 19 20 21 22 23 24
 25 26 27 28 29 30 31

*/
```
実行するとこのように表示されます
日付まで入力すると当日の色が反転して表示されます。
