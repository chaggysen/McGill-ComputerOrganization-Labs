.global _start
array: .word 3, 4, 5, 4 // array
n: .word 4 // size of array
log2_n: .word 0 // log2_n
mean: .word 0 // mean

_start:
LDR R0, =array // R0=array start address
LDR R1, n // size of the array
LDR R2, log2_n // log2_n
LDR R3, mean // mean 

WHILE:
LSL R6, R2, #1 // 1 << log2_n
CMP R6, R1 // ((1 << log2_n) < n)
BLT INCREMENT // increment log_2 by 1 if less then
B LOOP

INCREMENT:
ADD R2, R2, #1 // increment by 1
B WHILE

LOOP:
CMP R1, #0 // compare size of array with 0
BEQ MEAN
LDR R7, [R0], #4 // post-index mode
ADD R3, R3, R7 // mean += array[i]
SUBS R1, R1, #1 // decrement 
B LOOP

MEAN:
ASR R3, R3, R2 //mean = mean >> log2_n;
MOV R1, #4 // reset array length
MOV R0, #0 // reset beginning of array
B CENTER

CENTER:
CMP R1, #0 // compare size of array with 0
BEQ END
LDR R7, [R0] // load content of array in R7
SUBS R8, R7, R3 // array[i] - mean
STR R8, [R0]
ADD R0, R0, #4 // increment array pointer
SUBS R1, R1, #1 // decrement 
B CENTER

END:
B END
