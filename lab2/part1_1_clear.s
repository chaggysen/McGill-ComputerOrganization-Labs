.global _start
_start:

HEX0 = 0x00000001
HEX1 = 0x00000002
HEX2 = 0x00000004
HEX3 = 0x00000008
HEX4 = 0x00000010
HEX5 = 0x00000020

.equ HEX_MEMORY_A, 0xFF200020 
.equ HEX_MEMORY_B, 0xFF200030 
.equ light_A, 0x7F7F7F7F
.equ light_B, 0x7F7F7F7F

.equ test, 0x0000011
LDR R0, =test

// counter from 0
MOV R4, #0
// we need a 1 to check for hex indices
MOV R3, #1
// load address of memory A to R1
LDR R1, =HEX_MEMORY_A
// load address of memory B to R2
LDR R2, =HEX_MEMORY_B
// register to store display_on_off_values
LDR R6, =light_A
STR R6, [R1]
LDR R7, =light_B
STR R7, [R2]

// The subroutine will turn on all the segments of the HEX displays passed in the argument.
// It receives the HEX displays indices through R0 register as an argument.
HEX_clear_ASM: 
CMP R4, #6
BEQ END
// AND the hex address with 1 and store it in R5
AND R5, R0, R3
// compare the result to 0
CMP R5, #0
BGT clear_up_display
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

clear_up_display:
CMP R4, #0
BEQ clear_0
CMP R4, #1
BEQ clear_1
CMP R4, #2
BEQ clear_2
CMP R4, #3
BEQ clear_3
CMP R4, #4
BEQ clear_4
CMP R4, #5
BEQ clear_5

clear_0:
SUB R6, R6, #0x0000007F
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

clear_1:
SUB R6, R6, #0x00007F00
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

clear_2:
SUB R6, R6, #0x007F0000
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

clear_3:
SUB R6, R6, #0x7F000000
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

clear_4:
SUB R7, R7, #0x0000007F
STR R7, [R2]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

clear_5:
SUB R7, R7, #0x00007F00
STR R7, [R2]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_clear_ASM

END:
B END
	
	