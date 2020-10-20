.global _start
_start:
	
.equ HEX_MEMORY_A, 0xFF200020 
LDR R10, =HEX_MEMORY_A

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

// PUSHBUTTON ADDRESSES---------------------------------
.equ PB_DATA_ADDRESS, 0xFF200050

//Each bit in the Edgecapture register is set to by the parallel port when the corresponding key is pressed.
.equ PB_EDGE_ADDRESS, 0xFF20005C

//  An interrupt service routine can read this register to determine which key has been pressed.
.equ PB_INT_ADDRESS, 0xFF200058

// SWITCHES ADDRESSES------------------------------------
// Sider Switches Driver
.equ SW_MEMORY, 0xFF200040
// LEDs Driver
.equ LED_MEMORY, 0xFF200000
MOV R7, #0
// LOOP
Loop:
MOV R7, #0 // reset r7
BL read_slider_switches_ASM
BL write_LEDs_ASM
BL read_PB_data_ASM
BL read_PB_edgecp_ASM
MOV R5, #0// COUNTER
MOV R6, #1// AND 1
B DISPLAY_VALUE
B Loop

// PUSHBUTTON SUBROUTINES--------------------------------

read_PB_data_ASM:
LDR R1, =PB_DATA_ADDRESS
LDR R2, [R1] // use R2 to store the index
BX LR

read_PB_edgecp_ASM: 
LDR R1, =PB_EDGE_ADDRESS
LDR R3, [R1]
BX LR

// SWITCHES SUBROUTINES-----------------------------------
// returns the state of slider switches in R0
/* The EQU directive gives a symbolic name to a numeric constant,
a register-relative value or a PC-relative value. */
read_slider_switches_ASM:
    LDR R1, =SW_MEMORY
    LDR R0, [R1] // use R0 to store the value 
    BX LR
// LEDs Driver
// writes the state of LEDs (On/Off state) in R0 to the LEDs memory location
write_LEDs_ASM:
    LDR R1, =LED_MEMORY
    STR R0, [R1] // // use R0 to store the value 
    BX LR
// HEX SUBROUTINES---------------------------------------
DISPLAY_VALUE:
CMP R0, #0
LDREQ R9, =display_0
CMP R0, #1
LDREQ R9, =display_1
CMP R0, #2
LDREQ R9, =display_2
CMP R0, #3
LDREQ R9, =display_3
CMP R0, #4
LDREQ R9, =display_4
CMP R0, #5
LDREQ R9, =display_5
CMP R0, #6
LDREQ R9, =display_6
CMP R0, #7
LDREQ R9, =display_7
CMP R0, #8
LDREQ R9, =display_8
CMP R0, #9
LDREQ R9, =display_9
CMP R0, #10
LDREQ R9, =display_10
CMP R0, #11
LDREQ R9, =display_11
CMP R0, #12
LDREQ R9, =display_12
CMP R0, #13
LDREQ R9, =display_13
CMP R0, #14
LDREQ R9, =display_14
CMP R0, #15
LDREQ R9, =display_15

CMP R5, #4
BEQ Loop
AND R8, R3, R6
CMP R8, #0
BGT light_up_display
ADD R5, R5, #1
LSL R6, #1
B DISPLAY_VALUE

light_up_display:
CMP R5, #0
BEQ light_0
CMP R5, #1
BEQ light_1
CMP R5, #2
BEQ light_2
CMP R5, #3
BEQ light_3

light_0:
ADD R7, R7, R9
STR R7, [R10]
ADD R5, R5, #1
LSL R6, #1
B DISPLAY_VALUE

light_1:
MOV R11, #256
MUL R9, R9, R11
ADD R7, R7, R9
STR R7, [R10]
ADD R5, R5, #1
LSL R6, #1
B DISPLAY_VALUE

light_2:
MOV R11, #65536
MUL R9, R9, R11
ADD R7, R7, R9
STR R7, [R10]
ADD R5, R5, #1
LSL R6, #1
B DISPLAY_VALUE

light_3:
MOV R11, #16777216
MUL R9, R9, R11
ADD R7, R7, R9
STR R7, [R10]
ADD R5, R5, #1
LSL R6, #1
B DISPLAY_VALUE
	
	