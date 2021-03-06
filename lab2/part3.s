.section .vectors, "ax"
B _start
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector

.equ HEX_MEMORY_A, 0xFF200020 
.equ HEX_MEMORY_B, 0xFF200030
LDR R10, =HEX_MEMORY_A
LDR R11, =HEX_MEMORY_B

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

.equ load_address, 0xFFFEC600
.equ counter_address, 0xFFFEC604
.equ control_address, 0xFFFEC608 
.equ interrupt_status, 0xFFFEC60C
PB_int_flag :
    .word 0x0
tim_int_flag :
    .word 0x0

.text
.global _start

_start:
    LDR R12, =0x1E8480
    /* Set up stack pointers for IRQ and SVC processor modes */
    MOV        R1, #0b11010010      // interrupts masked, MODE = IRQ
    MSR        CPSR_c, R1           // change to IRQ mode
    LDR        SP, =0xFFFFFFFF - 3  // set IRQ stack to A9 onchip memory
    /* Change to SVC (supervisor) mode with interrupts disabled */
    MOV        R1, #0b11010011      // interrupts masked, MODE = SVC
    MSR        CPSR, R1             // change to supervisor mode
    LDR        SP, =0x3FFFFFFF - 3  // set SVC stack to top of DDR3 memory
    BL     CONFIG_GIC           // configure the ARM GIC
    // To DO: write to the pushbutton KEY interrupt mask register
    // Or, you can call enable_PB_INT_ASM subroutine from previous task
    // to enable interrupt for ARM A9 private timer, use ARM_TIM_config_ASM subroutine
    LDR        R0, =0xFF200050      // pushbutton KEY base address
    MOV        R1, #0xF             // set interrupt mask bits
    STR        R1, [R0, #0x8]       // interrupt mask register (base + 8)
	LDR R0, =load_address
	STR R12, [R0]
	LDR R0, =control_address
	MOV R1, #15
	STR R1, [R0]              
    // enable IRQ interrupts in the processor
    MOV        R0, #0b01010011      // IRQ unmasked, MODE = SVC
    MSR        CPSR_c, R0
IDLE:
	MOV R0, #0 // 0.00
	MOV R1, #0 // 0.0
	MOV R2, #0 // 0
	MOV R3, #0 // 00.00
	MOV R4, #0 // 0.00.00
	MOV R5, #0 // 00.00.00
	
	MOV R8, #0 // total HEX dislay value
	MOV R9, #0
    B MAIN_LOOP // This is where you write your objective task

MAIN_LOOP:
PUSH {R0-R12}
LDR R10, =PB_int_flag
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
LDR R10, =PB_int_flag
MOV R11, #0x00000000
STR R11, [R10]
B DISPLAY_VALUE_0

BEFORE_LOOP_STOP:
LDR R10, =PB_int_flag
MOV R11, #0x00000000
STR R11, [R10]
B LOOP_STOP

BEFORE_LOOP_RESET:
LDR R10, =PB_int_flag
MOV R11, #0x00000000
STR R11, [R10]
B LOOP_RESET


LOOP_STOP:
PUSH {R0-R12}
LDR R10, =PB_int_flag
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
LDR R0, =PB_int_flag
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
LDR R0, =PB_int_flag
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
B Check_INT

Check_INT:
LDR R11, =tim_int_flag
LDR R12, [R11]
CMP R12, #1 
BEQ ARM_TIM_clear_INT_ASM
B Check_INT

ARM_TIM_clear_INT_ASM: 
LDR R10, =tim_int_flag
MOV R11, #0
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
LDR R10, =PB_int_flag
LDR R11, [R10]
CMP R11, #1
BEQ BEFORE_MAIN
CMP R11, #2
BEQ BEFORE_LOOP_STOP
CMP R11, #4
BEQ BEFORE_LOOP_RESET
POP {R0-R12}
B DISPLAY_VALUE_0

/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR

/* To Do: Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */
 ARM_TIMER_CHECK:
 CMP R5, #29
 BNE Pushbutton_check
 BL  ARM_TIM_ISR
 B EXIT_IRQ
 Pushbutton_check:
    CMP R5, #73
UNEXPECTED:
    BNE UNEXPECTED      // if not recognized, stop here
    BL KEY_ISR
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ

CONFIG_GIC:
    PUSH {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
/* To Do: you can configure different interrupts
   by passing their IDs to R0 and repeating the next 3 lines */
    MOV R0, #73            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT
	MOV R0, #29            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT
/* configure the GIC CPU Interface */
    LDR R0, =0xFFFEC100    // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
    LDR R1, =0xFFFF        // enable interrupts of all priorities levels
    STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
    MOV R1, #1
    STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
    LDR R0, =0xFFFED000
    STR R1, [R0]
    POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
    PUSH {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
    LSR R4, R0, #3    // calculate reg_offset
    BIC R4, R4, #3    // R4 = reg_offset
    LDR R2, =0xFFFED100
    ADD R4, R2, R4    // R4 = address of ICDISER
    AND R2, R0, #0x1F // N mod 32
    MOV R5, #1        // enable
    LSL R2, R5, R2    // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
    LDR R3, [R4]      // read current register value
    ORR R3, R3, R2    // set the enable bit
    STR R3, [R4]      // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
    BIC R4, R0, #3    // R4 = reg_offset
    LDR R2, =0xFFFED800
    ADD R4, R2, R4    // R4 = word address of ICDIPTR
    AND R2, R0, #0x3  // N mod 4
    ADD R4, R2, R4    // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
    STRB R1, [R4]
    POP {R4-R5, PC}

KEY_ISR:
    LDR R0, =0xFF200050    // base address of pushbutton KEY port
    LDR R1, [R0, #0xC]     // read edge capture register
    MOV R2, #0xF
    STR R2, [R0, #0xC]     // clear the interrupt
	LDR R0, =PB_int_flag
	STR R1, [R0]
	BX LR
	
ARM_TIM_ISR:
    LDR R0, =interrupt_status    // base address 
    LDR R1, [R0]     
    MOV R2, #1
    STR R2, [R0]     // clear the interrupt
	LDR R0, =tim_int_flag
	STR R1, [R0]
	BX LR
	
CHECK_KEY0:
    MOV R3, #0x1
    ANDS R3, R3, R1        // check for KEY0
    BEQ CHECK_KEY1
    MOV R2, #0b00111111
    STR R2, [R0]           // display "0"
    B END_KEY_ISR
CHECK_KEY1:
    MOV R3, #0x2
    ANDS R3, R3, R1        // check for KEY1
    BEQ CHECK_KEY2
    MOV R2, #0b00000110
    STR R2, [R0]           // display "1"
    B END_KEY_ISR
CHECK_KEY2:
    MOV R3, #0x4
    ANDS R3, R3, R1        // check for KEY2
    BEQ IS_KEY3
    MOV R2, #0b01011011
    STR R2, [R0]           // display "2"
    B END_KEY_ISR
IS_KEY3:
    MOV R2, #0b01001111
    STR R2, [R0]           // display "3"
END_KEY_ISR:
    BX LR
	
END:
B END
	