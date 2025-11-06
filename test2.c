#include <stdio.h>
#include "myalloc.h"

/*
Testing Free
*/
int main()
{

    myAllocInit();

    int *intPtr = (int *)myAlloc(sizeof(int));
    int *intPtr2 = (int *)myAlloc(sizeof(int));

    *intPtr = 18;
    *intPtr2 = 44;

    printf("Pointer intPtr[%p] and Value[%d]\n", intPtr, *intPtr);
    printf("Pointer intPtr2[%p] and Value[%d]\n", intPtr2, *intPtr2);
    
    myFree(intPtr);

    int *intPtr3 = (int *)myAlloc(sizeof(int));
    printf("Pointer intPtr3[%p] and Value[%d]\n", intPtr3, *intPtr3);

    int *intPtr4 = (int *)myAlloc(sizeof(int));
    printf("Pointer intPtr4[%p] and Value[%d]\n", intPtr4, *intPtr4);

    return 0;
}