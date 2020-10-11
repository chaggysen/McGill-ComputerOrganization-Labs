.global _start
_start:

MOV R0, #1 // xi = 1
MOV R1, #168 // a = 168
MOV R2, #100 // cnt = 100
MOV R3, #0 // grad


FUNCTION:
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
BL FUNCTION

END:
B END
