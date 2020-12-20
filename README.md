# McGill-ComputerOrganization-Labs

## Lab 1:
Learn how to work with an ARM processor and the basics of ARM assembly by programming some common routines.

### Part 1:
Implement a well-known optimization technique, namely stochastic gradient descent (SGD), which is the backbone of a wide range of machine learning algorithms. Use the SGD technique to solve a simple problem: finding the square root of an integer number.

### Part 2:
In this part, calculate the norm of a vector (array).

### Part 3:
Implement an algorithm that “centers” a vector (array). It is often necessary to ensure that a signal is “centered” (that is, its average is 0). For example, DC signals can damage a loudspeaker, so it is important to center an audio signal to remove DC components before sending the signal to the speaker. The program should be able to accept the signal length as an input parameter.

## Lab 2:
This lab introduces the basic I/O capabilities of the DE1-SoC computer, more specifically, the slider switches, pushbuttons, LEDs, 7-Segment (HEX) displays and timers. After writing assembly drivers that interface with the I/O components, timers and interrupts are used to demonstrate polling and interrupt based applications.

### Part 1:
1. HEX displays: There are 6 HEX displays (HEX0 to HEX5) on the DE1-SoC Computer board. You are required to write three subroutines to implement the functions listed below to control the HEX displays:
HEX_clear_ASM: The subroutine will turn off all the segments of the HEX displays passed in the argument. It receives the HEX displays indices through R0 register as an argument.
HEX_flood_ASM: The subroutine will turn on all the segments of the HEX displays passed in the argument. It receives the HEX displays indices through R0 register as an argument.
HEX_write_ASM: The subroutine receives the HEX displays indices and an integer value between 0-15 through R0 and R1 registers as an arguments, respectively. Based on the second argument value (R1), the subroutine will display the corresponding hexadecimal digit (0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F) on the display(s).

2. Pushbuttons: There are 4 Pushbuttons (PB0 to PB3) on the DE1-SoC Computer board. You are required to write seven subroutines to implement the functions listed below to control the pushbuttons:
read_PB_data_ASM: The subroutine returns the indices of the pressed pushbuttons (the keys form the pushbuttons Data register). The indices are encoded based on a one-hot encoding scheme:
PB0 = 0x00000001
PB1 = 0x00000002
PB2 = 0x00000004
PB3 = 0x00000008
PB_data_is_pressed_ASM: The subroutine receives pushbuttons indices as an argument (One index at a time). Then, it returns 0x00000001 when the the corresponding pushbutton is pressed.
read_PB_edgecp_ASM: The subroutine returns the indices of the pushbuttons that have been pressed and then released (the edge bits form the pushbuttons Edgecapture register).
PB_edgecp_is_pressed_ASM: The subroutine receives pushbuttons indices as an argument (One index at a time). Then, it returns 0x00000001 when the the corresponding pushbutton has been asserted.
PB_clear_edgecp_ASM: The subroutine clears the pushbuttons Edgecapture register. You can read the edgecapture register and write what you just read back to the edgecapture register to clear it.
enable_PB_INT_ASM: The subroutine receives pushbuttons indices as an argument. Then, it enables the interrupt function for the corresponding pushbuttons by setting the interrupt mask bits to '1'.
disable_PB_INT_ASM: The subroutine receives pushbuttons indices as an argument. Then, it disables the interrupt function for the corresponding pushbuttons by setting the interrupt mask bits to '0'.

### Part 2:
There is one ARM A9 private timer available on the DE1-SoC Computer board. The timer uses a clock frequency of 200 MHz. You need to configure the timer before using it. To configure the timer, you need to pass three arguments to the “configuration subroutine”. The arguments are:

1. Load value: ARM A9 private timer is a down counter and requires initial count value. Use R0 to pass this argument.

2. Configuration bits: Use R1 to pass this argument. Read sections 2.4.1 (p. 3) and 3.1 (p. 14) in the De1-SoC Computer Manual carefully to learn how to handle the configuration bits. The configuration bits are stored in the Control register of the timer.

You are required to write three subroutines to implement the functions listed below to control the timers:

ARM_TIM_config_ASM: The subroutine is used to configure the timer. Use the arguments discussed above to configure the timer.
ARM_TIM_read_INT_ASM: The subroutine returns the “F” value (0x00000000 or 0x00000001) from the ARM A9 private timer Interrupt status register.
ARM_TIM_clear_INT_ASM: The subroutine clears the “F” value in the ARM A9 private timer Interrupt status register. The F bit can be cleared to 0 by writing a 0x00000001 into the Interrupt status register.

