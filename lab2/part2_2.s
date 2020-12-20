.global _start
_start:

// increment for 10ms
const: .word 2000000
LDR R12, const

.equ HEX_MEMORY_A, 0xFF200020 
.equ HEX_MEMORY_B, 0xFF200030
LDR R10, =HEX_MEMORY_A
LDR R11, =HEX_MEMORY_B

.equ load_address, 0xFFFEC600
.equ counter_address, 0xFFFEC604
.equ control_address, 0xFFFEC608 
.equ interrupt_status, 0xFFFEC60C
.equ PG_edge_register, 0xFF20005C

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

MOV R0, #0 // 0.00
MOV R1, #0 // 0.0
MOV R2, #0 // 0
MOV R3, #0 // 00.00
MOV R4, #0 // 0.00.00
MOV R5, #0 // 00.00.00

MOV R8, #0 // total HEX dislay value
MOV R9, #0

MAIN_LOOP:
PUSH {R0-R12}
LDR R10, =PG_edge_register
LDR R11, [R10]
CMP R11, #1
BEQ BEFORE_MAIN
CMP R11, #2
BEQ BEFORE_LOOP_STOP
CMP R11, #4
BEQ BEFORE_LOOP_RESET
POP {R0-R12}
B MAIN_LOOP

BEFORE_MAIN:
LDR R10, =PG_edge_register
MOV R11, #0x0000000F
STR R11, [R10]
B DISPLAY_VALUE_0

BEFORE_LOOP_STOP:
LDR R10, =PG_edge_register
MOV R11, #0x0000000F
STR R11, [R10]
B LOOP_STOP

BEFORE_LOOP_RESET:
LDR R10, =PG_edge_register
MOV R11, #0x0000000F
STR R11, [R10]
B LOOP_RESET

LOOP_STOP:
PUSH {R0-R12}
LDR R10, =PG_edge_register
LDR R11, [R10]
CMP R11, #1
BEQ BEFORE_MAIN
CMP R11, #2
BEQ BEFORE_LOOP_STOP
CMP R11, #4
BEQ BEFORE_LOOP_RESET
POP {R0-R12}
B LOOP_STOP

LOOP_RESET:
MOV R0, #0 // 0.00
MOV R1, #0 // 0.0
MOV R2, #0 // 0
MOV R3, #0 // 00.00
MOV R4, #0 // 0.00.00
MOV R5, #0 // 00.00.00
PUSH {R0-R12}
LDR R0, =PG_edge_register
LDR R1, [R0]
CMP R1, #1
BEQ BEFORE_MAIN
CMP R1, #2
BEQ BEFORE_LOOP_STOP
CMP R1, #4
BEQ BEFORE_LOOP_RESET
POP {R0-R12}
BL DISPLAY_VALUE_FOR_RESET
B LOOP_RESET

DISPLAY_VALUE_FOR_RESET:
PUSH {R0-R12}
LDR R10, =HEX_MEMORY_A
LDR R11, =HEX_MEMORY_B
LDR R0 , =0x3F3F3F3F
LDR R1, =0x00003F3F
STR R0, [R10]
STR R1, [R11]
POP {R0-R12}
BX LR

DISPLAY_VALUE_0:
PUSH {R0-R12}
LDR R0, =PG_edge_register
LDR R1, [R0]
CMP R1, #1
BEQ BEFORE_MAIN
CMP R1, #2
BEQ BEFORE_LOOP_STOP
CMP R1, #4
BEQ BEFORE_LOOP_RESET
POP {R0-R12}
MOV R8, #0 // total HEX dislay value
MOV R9, #0
LDR R10, =HEX_MEMORY_A
LDR R11, =HEX_MEMORY_B
CMP R0, #0
LDREQ R6, =display_0
CMP R0, #1
LDREQ R6, =display_1
CMP R0, #2
LDREQ R6, =display_2
CMP R0, #3
LDREQ R6, =display_3
CMP R0, #4
LDREQ R6, =display_4
CMP R0, #5
LDREQ R6, =display_5
CMP R0, #6
LDREQ R6, =display_6
CMP R0, #7
LDREQ R6, =display_7
CMP R0, #8
LDREQ R6, =display_8
CMP R0, #9
LDREQ R6, =display_9
B displays_0

displays_0:
ADD R8, R8, R6
STR R8, [R10]
B DISPLAY_VALUE_1

DISPLAY_VALUE_1:
CMP R1, #0
LDREQ R6, =display_0
CMP R1, #1
LDREQ R6, =display_1
CMP R1, #2
LDREQ R6, =display_2
CMP R1, #3
LDREQ R6, =display_3
CMP R1, #4
LDREQ R6, =display_4
CMP R1, #5
LDREQ R6, =display_5
CMP R1, #6
LDREQ R6, =display_6
CMP R1, #7
LDREQ R6, =display_7
CMP R1, #8
LDREQ R6, =display_8
CMP R1, #9
LDREQ R6, =display_9
B displays_1

displays_1:
MOV R7, #256
MUL R6, R6, R7
ADD R8, R8, R6
STR R8, [R10]
B DISPLAY_VALUE_2

DISPLAY_VALUE_2:
CMP R2, #0
LDREQ R6, =display_0
CMP R2, #1
LDREQ R6, =display_1
CMP R2, #2
LDREQ R6, =display_2
CMP R2, #3
LDREQ R6, =display_3
CMP R2, #4
LDREQ R6, =display_4
CMP R2, #5
LDREQ R6, =display_5
CMP R2, #6
LDREQ R6, =display_6
CMP R2, #7
LDREQ R6, =display_7
CMP R2, #8
LDREQ R6, =display_8
CMP R2, #9
LDREQ R6, =display_9
B displays_2

displays_2:
MOV R7, #65536
MUL R6, R6, R7
ADD R8, R8, R6
STR R8, [R10]
B DISPLAY_VALUE_3

DISPLAY_VALUE_3:
CMP R3, #0
LDREQ R6, =display_0
CMP R3, #1
LDREQ R6, =display_1
CMP R3, #2
LDREQ R6, =display_2
CMP R3, #3
LDREQ R6, =display_3
CMP R3, #4
LDREQ R6, =display_4
CMP R3, #5
LDREQ R6, =display_5
CMP R3, #6
LDREQ R6, =display_6
B displays_3

displays_3:
MOV R7, #16777216
MUL R6, R6, R7
ADD R8, R8, R6
STR R8, [R10]
B DISPLAY_VALUE_4

DISPLAY_VALUE_4:
CMP R4, #0
LDREQ R6, =display_0
CMP R4, #1
LDREQ R6, =display_1
CMP R4, #2
LDREQ R6, =display_2
CMP R4, #3
LDREQ R6, =display_3
CMP R4, #4
LDREQ R6, =display_4
CMP R4, #5
LDREQ R6, =display_5
CMP R4, #6
LDREQ R6, =display_6
CMP R4, #7
LDREQ R6, =display_7
CMP R4, #8
LDREQ R6, =display_8
CMP R4, #9
LDREQ R6, =display_9
B displays_4

displays_4:
ADD R9, R9, R6
STR R9, [R11]
B DISPLAY_VALUE_5

DISPLAY_VALUE_5:
CMP R5, #0
LDREQ R6, =display_0
CMP R5, #1
LDREQ R6, =display_1
CMP R5, #2
LDREQ R6, =display_2
CMP R5, #3
LDREQ R6, =display_3
CMP R5, #4
LDREQ R6, =display_4
CMP R5, #5
LDREQ R6, =display_5
CMP R5, #6
LDREQ R6, =display_6
B displays_5

displays_5:
MOV R7, #256
MUL R6, R6, R7
ADD R9, R9, R6
STR R9, [R11]
B ARM_TIM_config_ASM

ARM_TIM_config_ASM:
LDR R10, =load_address
STR R12, [R10]
LDR R10, =control_address
MOV R11, #1
STR R11, [R10]
B Check_INT

Check_INT:
BL ARM_TIM_read_INT_ASM
CMP R11, #1
BLEQ ARM_TIM_clear_INT_ASM
B Check_INT

// The subroutine returns the “F” value from the ARM A9 private timer Interrupt status register.
ARM_TIM_read_INT_ASM:
LDR R10, =interrupt_status
LDR R11, [R10]
BX LR

// The subroutine clears the “F” value in the ARM A9 private timer Interrupt status register.
ARM_TIM_clear_INT_ASM: 
LDR R10, =interrupt_status
MOV R11, #0x00000001
STR R11, [R10]
B UPDATE_VALUES

UPDATE_VALUES:
ADD R0, R0, #1
CMP R0, #10
ADDEQ R1, R1, #1
MOVEQ R0, #0

CMP R1, #10
ADDEQ R2, R2, #1
MOVEQ R1, #0

CMP R2, #10
ADDEQ R3, R3, #1
MOVEQ R2, #0

CMP R3, #6
ADDEQ R4, R4, #1
MOVEQ R3, #0

CMP R4, #10
ADDEQ R5, R5, #1
MOVEQ R4, #0

CMP R5, #6
BEQ END
PUSH {R0-R12}
LDR R10, =PG_edge_register
LDR R11, [R10]
CMP R11, #1
BEQ BEFORE_MAIN
CMP R11, #2
BEQ BEFORE_LOOP_STOP
CMP R11, #4
BEQ BEFORE_LOOP_RESET
POP {R0-R12}
B DISPLAY_VALUE_0

END:
B END
	