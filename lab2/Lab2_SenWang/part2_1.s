.global _start
_start:
	
const: .word 200000000

.equ HEX_MEMORY_A, 0xFF200020 
LDR R10, =HEX_MEMORY_A

.equ load_address, 0xFFFEC600
.equ counter_address, 0xFFFEC604
.equ control_address, 0xFFFEC608 
.equ interrupt_status, 0xFFFEC60C

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

LDR R0, const
MOV R6, #0 // counter starting at 0

MAIN_LOOP:
CMP R6, #16
BEQ END
BL DISPLAY_VALUE
BL ARM_TIM_config_ASM
BL Check_INT


DISPLAY_VALUE:
CMP R6, #0
LDREQ R2, =display_0
CMP R6, #1
LDREQ R2, =display_1
CMP R6, #2
LDREQ R2, =display_2
CMP R6, #3
LDREQ R2, =display_3
CMP R6, #4
LDREQ R2, =display_4
CMP R6, #5
LDREQ R2, =display_5
CMP R6, #6
LDREQ R2, =display_6
CMP R6, #7
LDREQ R2, =display_7
CMP R6, #8
LDREQ R2, =display_8
CMP R6, #9
LDREQ R2, =display_9
CMP R6, #10
LDREQ R2, =display_10
CMP R6, #11
LDREQ R2, =display_11
CMP R6, #12
LDREQ R2, =display_12
CMP R6, #13
LDREQ R2, =display_13
CMP R6, #14
LDREQ R2, =display_14
CMP R6, #15
LDREQ R2, =display_15
STR R2, [R10]
BX LR

// The subroutine is used to configure the timer.
ARM_TIM_config_ASM:
LDR R2, =load_address // store the start value
STR R0, [R2]
LDR R2, =control_address // start the timer
MOV R3, #1
STR R3, [R2]
BX LR

Check_INT:
BL ARM_TIM_read_INT_ASM
CMP R3, #1
BLEQ ARM_TIM_clear_INT_ASM
B Check_INT

// The subroutine returns the “F” value from the ARM A9 private timer Interrupt status register.
ARM_TIM_read_INT_ASM:
LDR R2, =interrupt_status
LDR R3, [R2]
BX LR

// The subroutine clears the “F” value in the ARM A9 private timer Interrupt status register.
ARM_TIM_clear_INT_ASM: 
LDR R2, =interrupt_status
MOV R3, #0x00000001
STR R3, [R2]
ADD R6, R6, #1
B MAIN_LOOP

END:
B END
	
	