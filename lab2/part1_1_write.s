.global _start
_start:

.equ HEX_MEMORY_A, 0xFF200020 
.equ HEX_MEMORY_B, 0xFF200030 
.equ light_A, 0x7F7F7F7F
.equ light_B, 0x7F7F7F7F

.equ index, 0x000000C
LDR R0, =index

.equ value, 0x0000000B
LDR R1, =value

// display values
.equ display_0, 0x0000003F
.equ display_1, 0x00000006
.equ display_2, 0x0000005B
.equ display_3, 0x0000004F
.equ display_4, 0x00000066
.equ display_5, 0x0000006D
.equ display_6, 0x0000007D
.equ display_7, 0x00000007
.equ display_8, 0x0000007F
.equ display_9, 0x00000067
.equ display_10, 0x00000077
.equ display_11, 0x0000007C
.equ display_12, 0x00000039
.equ display_13, 0x0000005E
.equ display_14, 0x00000079
.equ display_15, 0x00000071

// counter from 0
MOV R5, #0
// we need a 1 to check for hex indices
MOV R4, #1
// load address of memory A to R1
LDR R2, =HEX_MEMORY_A
// load address of memory B to R2
LDR R3, =HEX_MEMORY_B
// register to store display_values
MOV R7, #0
MOV R8, #0

// The subroutine will turn on all the segments of the HEX displays passed in the argument.
// It receives the HEX displays indices through R0 register as an argument.
HEX_flood_ASM: 
// get R1 value
CMP R1, #0
LDREQ R9, =display_0
CMP R1, #1
LDREQ R9, =display_1
CMP R1, #2
LDREQ R9, =display_2
CMP R1, #3
LDREQ R9, =display_3
CMP R1, #4
LDREQ R9, =display_4
CMP R1, #5
LDREQ R9, =display_5
CMP R1, #6
LDREQ R9, =display_6
CMP R1, #7
LDREQ R9, =display_7
CMP R1, #8
LDREQ R9, =display_8
CMP R1, #9
LDREQ R9, =display_9
CMP R1, #10
LDREQ R9, =display_10
CMP R1, #11
LDREQ R9, =display_11
CMP R1, #12
LDREQ R9, =display_12
CMP R1, #13
LDREQ R9, =display_13
CMP R1, #14
LDREQ R9, =display_14
CMP R1, #15
LDREQ R9, =display_15

CMP R5, #6
BEQ END

// AND the hex address with 1 and store it in R5
AND R6, R0, R4
// compare the result to 0
CMP R6, #0
BGT light_up_display
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

light_up_display:
CMP R5, #0
BEQ light_0
CMP R5, #1
BEQ light_1
CMP R5, #2
BEQ light_2
CMP R5, #3
BEQ light_3
CMP R5, #4
BEQ light_4
CMP R5, #5
BEQ light_5

light_0:
ADD R7, R7, R9
STR R7, [R2]
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

light_1:
MOV R10, #256
MUL R9, R9, R10
ADD R7, R7, R9
STR R7, [R2]
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

light_2:
MOV R10, #65536
MUL R9, R9, R10
ADD R7, R7, R9
STR R7, [R2]
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

light_3:
MOV R10, #16777216
MUL R9, R9, R10
ADD R7, R7, R9
STR R7, [R2]
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

light_4:
ADD R8, R8, R9
STR R8, [R3]
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

light_5:
MOV R10, #256
MUL R9, R9, R10
ADD R8, R8, R9
STR R8, [R3]
// increment counter
ADD R5, R5, #1
// shift the bit
LSL R4, #1
B HEX_flood_ASM

END:
B END
	
	