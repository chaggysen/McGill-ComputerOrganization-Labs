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
MOV R6, #0
MOV R7, #0

// The subroutine will turn on all the segments of the HEX displays passed in the argument.
// It receives the HEX displays indices through R0 register as an argument.
HEX_flood_ASM: 
CMP R4, #6
BEQ END
// AND the hex address with 1 and store it in R5
AND R5, R0, R3
// compare the result to 0
CMP R5, #0
BGT light_up_display
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

light_up_display:
CMP R4, #0
BEQ light_0
CMP R4, #1
BEQ light_1
CMP R4, #2
BEQ light_2
CMP R4, #3
BEQ light_3
CMP R4, #4
BEQ light_4
CMP R4, #5
BEQ light_5

light_0:
ADD R6, R6, #0x0000007F
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

light_1:
ADD R6, R6, #0x00007F00
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

light_2:
ADD R6, R6, #0x007F0000
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

light_3:
ADD R6, R6, #0x7F000000
STR R6, [R1]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

light_4:
ADD R7, R7, #0x0000007F
STR R7, [R2]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

light_5:
ADD R7, R7, #0x00007F00
STR R7, [R2]
// increment counter
ADD R4, R4, #1
// shift the bit
LSL R3, #1
B HEX_flood_ASM

END:
B END
	