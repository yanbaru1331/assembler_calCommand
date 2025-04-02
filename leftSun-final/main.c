#include <stdio.h>
#include <stdlib.h>
char pool[BUFSIZ] = "abcdef";
extern int calendar(int y, int m, char *ar, int day);
int main(int argc, char *argv[]){
    int y, m, day;
    y =  atoi(argv[1]);
    m =  atoi(argv[2]);
    if (argc < 1){
        m = 1;
    }

    if (argc < 4){
        day = 110;
    }  
    else{
        day = atoi(argv[3]);
    }
    
    //printf("y = %d m = %d day = %d\n", y, m, day);
    calendar(y, m, pool, day);
    
    puts(pool);
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