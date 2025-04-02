#include <stdio.h>
#include <stdlib.h>
char pool[2048] = "abcdef";
extern int calendar(int y, int m, char *ar, int day);
int main(){
    int y, m, day;
    //scanf("%d", &y);
    y = 2024;
    m = 0;
    day = 101;
    calendar(y, m, pool, day);
    
    puts(pool);
    //printf("%d\n", day);
    return 0;
}


/*
root@fdbbee098cb5:~# ./a.out 2022 12
y =2022 m = 12
              1  2  3
  4  5  6  7  8  9 10
 11 12 13 14 15 16 17
 18 19 20 21 22 23 24
 25 26 27 28 29 30 31

*/