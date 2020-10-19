.global _start
array: .word 5, 6, 7, 8 // array
n: .word 4 // size of array
log2_n: .word 0 // log2_n
_start:
LDR R0, =array // R0=array start address
LDR R1, n // size of the array
LDR R2, log2_n // log2_n
MOV R3, #0 // temp
MOV R4, #1 // norm
MOV R5, #100 // count

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
BEQ SQUARE_ROOT_START // end of loop go to square_rrot
LDR R7, [R0], #4 // post-index mode
MLA R3, R7, R7, R3 // tmp += (*ptr) * (*ptr) or R3=(R7*R7)+R3
SUBS R1, R1, #1 // decrement 
B LOOP

SQUARE_ROOT_START:
ASR R3, R3, R2 //tmp = tmp >> log2_n;
// Here, tmp is R3, norm is R4, cnt is R8, k=#10, t=#2
MOV R0, R4 // xi = norm
MOV R1, R3 // a = tmp
MOV R2, #100 // cnt = 100
MOV R3, #0 // grad
MOV R4, #0
MOV R5, #0
MOV R6, #0
B SQUARE_ROOT_FUNCTION

SQUARE_ROOT_FUNCTION:
CMP R2, #0
BEQ END
MUL R4, R0, R0 //xi*xi
SUBS R5, R4, R1 // (xi*xi)-a
MUL R6, R5, R0 // (xi*xi-a)*xi
ASR R6, R6, #10 // ((xi*xi-1)*xi)>>10
MOV R3, R6// load content of R6 in R3(grad)
CMP R3, #2 // if (grad > t)
MOVGT R3, #2
CMP R3, #-2 //(if grad < -t)
MOVLT R3, #-2
SUBS R0, R0, R3 //xi = xi - grad
SUBS R2, R2, #1 // counter - 1
BL SQUARE_ROOT_FUNCTION

END:
B END
