#ifndef _MYALLOC_H_
#define _MYALLOC_H_
void myAllocInit(void);
void* myAlloc(int size);
void myFree(void *ptr);
#endif