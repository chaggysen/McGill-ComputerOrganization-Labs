.global _start
array: .word 4, 2, 1, 4, -1
n: .word 5
_start:
LDR R0, =array // R0=array start address
LDR R1, n // size of the array
MOV R2, #0 // counter

first_loop:
CMP R2, #4
BEQ END // end first loop
LDR R3, [R0, R2, lsl#2] // int tmp = *(ptr + i);
MOV R4, R2 //cur_min_idx = i;
ADD R5, R2, #1 //j = i + 1
B second_loop

second_loop:
CMP R5, R1
BEQ swap
LDR R6, [R0, R5, lsl#2] //  R6 = *(ptr + j)
CMP R3, R6
BGT update
ADD R5, R5, #1 // incrment j
B second_loop

update:
MOV R3, R6 // tmp = *(ptr + j);
MOV R4, R5
ADD R5, R5, #1 // incrment j
B second_loop

swap:
LDR R3, [R0, R2, lsl#2] // int tmp = *(ptr + i);
LDR R7, [R0, R4, lsl#2] // *(ptr + cur_min_idx)
STR R7, [R0, R2, lsl#2] // *(ptr + i) = *(ptr + cur_min_idx);
STR R3, [R0, R4, lsl#2] // *(ptr + cur_min_idx) = tmp;
ADD R2, R2, #1 // increment i
B first_loop

END:
B END
