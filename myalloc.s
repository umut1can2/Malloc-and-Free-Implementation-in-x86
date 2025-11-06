.equ HDR_SIZE,              8
.equ HDR_AVAIL_OFFSET,      0
.equ HDR_SIZE_OFFSET,       4

.section .data
HeapBase: .long 0
HeapCurrentPtr: .long 0
HeapEnd : .long 0

.section .text
.type myAllocInit, @function
.type myAlloc, @function
.global myAllocInit
.global myAlloc
.global myFree
.type myFree, @function


myAllocInit:
    # get the Heap address and assign to HeapBase and HeapEnd
    movl $45, %eax 
    xorl %ebx, %ebx
    int $0x80
    
    movl %eax, HeapBase
    movl %eax, HeapEnd

    ret

myAlloc:
    pushl %ebp
    movl %esp, %ebp

    movl HeapBase, %eax
    movl HeapEnd,  %ebx
    movl 8(%ebp), %ecx

myAlloc_lp:
    # i-f we are at the end of the heap then extend heap
    cmpl %eax, %ebx
    je extend_heap
    
    # i-f still there is a space then search the available block
    # i-f block is not avail then go next_block
    movl HDR_AVAIL_OFFSET(%eax), %edx
    cmpl $0, %edx
    jne next_block
    # i-f space is smaller than we need then go next_block
    movl HDR_SIZE_OFFSET(%eax), %edx
    cmpl %ecx, %edx
    jl next_block
    
    # we found a suitable block for our allocation
    # we put 1 to mark the block as unavailable
    # also we set the size of the chunk in here
    # i don't put the new size! because after that program will crash
    # because i didn't use any splitting mechanism etc....
    movl $1, HDR_AVAIL_OFFSET(%eax)
    movl %eax, %edx

    addl HDR_SIZE_OFFSET(%eax), %eax
    addl $HDR_SIZE, %eax

    # process is completed return
    movl %edx, %eax
    addl $HDR_SIZE, %eax
    jmp myAlloc_end

next_block:
    # this block of code adds the offset for going to next block
    addl HDR_SIZE_OFFSET(%eax), %eax
    addl $HDR_SIZE, %eax

    jmp myAlloc_lp

extend_heap:
    # there is no suitable block for use or there is no enough space
    # extend the heap and allocate a new block for use
    movl HeapEnd, %ebx
    movl %ebx, %edx
    addl $HDR_SIZE, %ebx
    addl %ecx, %ebx

    movl $45, %eax
    int $0x80
    
    # again, here we initalize the values for the block ...
    movl %eax, HeapEnd
    movl $1, HDR_AVAIL_OFFSET(%edx)
    movl %ecx, HDR_SIZE_OFFSET(%edx)
    movl %edx, %eax
    addl $HDR_SIZE, %eax
    # process is completed
    jmp myAlloc_end

myAlloc_end:
    movl %ebp, %esp
    popl %ebp
    ret

# just sets the block as available
# nothing more..
myFree:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%esp), %eax
    subl $HDR_SIZE, %eax
    movl $0, HDR_AVAIL_OFFSET(%eax)

    movl %ebp, %esp
    popl %ebp
    ret
    
    #
    