#include <stdio.h>
#include <string.h>
#include "myalloc.h"
//
int main()
{
    myAllocInit();

    int *intPtr = (int *)myAlloc(sizeof(int));
    int *intPtr2 = (int *)myAlloc(sizeof(int));
    char *strPtr = (char *)myAlloc(16);
    int *intPtr3 = (int *)myAlloc(sizeof(int));
    //0x8ad2008 + 28 --1C
    *intPtr = 14;
    *intPtr2 = 25;
    *intPtr3 = 39;

    strcat(strPtr, "Selam!");
    printf("Pointer of intPtr : %p\n", intPtr);
    printf("Pointer of intPtr2 : %p\n", intPtr2);
    printf("Pointer of strPtr : %p\n", strPtr);
    printf("Pointer of intPtr3 : %p\n", intPtr3);

    printf("%d\n%d\n%d\n", *intPtr, *intPtr2, *intPtr3);
    printf("%s\n", strPtr);
    return 0;
}