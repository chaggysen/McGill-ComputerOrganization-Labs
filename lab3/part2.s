.global _start
_start:
		// addresses
		.equ pixel_buffer, 0xC8000000 // pixel buffer
		.equ char_buffer, 0xc9000000 // char buffer
		.equ ps2_address, 0xFF200100
        bl      input_loop
end:
        b       end

@ TODO: copy VGA driver here.
// draw point subroutine
VGA_draw_point_ASM:
		push {r0, r1, r6, r7}
		LSL R0, R0, #1 // (x << 1)
		LSL R1, R1, #10 // (y << 10) 
		MOV R6, #0// reset R6 to 0
		ADD R6, R0, R1 // add (x, y)
		LDR R7, =pixel_buffer // load pixel_buffer
		ADD R6, R6, R7 // add pixel_buffer to address
		STRH R2, [R6] // store color value into the pixel
		pop {r0, r1, r6, r7}
		BX LR

// write char subroutine
VGA_write_char_ASM:
		push {r1, r6, r7}
		LSL R1, R1, #7 // (y << 7) 
		MOV R6, #0// reset R6 to 0
		ADD R6, R0, R1 // add (x, y)
		LDR R7, =char_buffer // load pixel_buffer
		ADD R6, R6, R7 // add pixel_buffer to address
		STRB R2, [R6] // store color value into the pixel
		pop {r1, r6, r7}
		BX LR

// clear pixel buff subroutine
VGA_clear_pixelbuff_ASM:
		// initiate values
		MOV R0, #0 // start at x = 0
		MOV R1, #0 // start at y = 0
		MOV R2, #0 // set color = 0
		push {lr}
		BL clear_pixel // call clear
		pop {lr}
		BX LR

clear_pixel:
		push {lr}
		BL VGA_draw_point_ASM // call draw
		pop {lr}
		ADD R0, R0, #1 // increment x by 1
		CMP R0, #320 // compare with max x
		BLE clear_pixel
		ADD R1, R1, #1 // increment y by 1
		MOV R0, #0 // reset x to 0
		CMP R1, #240 // compare with max y
		BLE clear_pixel
		BX LR

// clear charbuff subroutine
VGA_clear_charbuff_ASM:
		// initiate values
		MOV R0, #0 // start at x = 0
		MOV R1, #0 // start at y = 0
		MOV R2, #0 // set color = 0
		push {lr}
		BL clear_char // call clear
		pop {lr}
		BX LR

clear_char:
		push {lr}
		BL VGA_write_char_ASM
		pop {lr}
		ADD R0, R0, #1 // increment x by 1
		CMP R0, #80 // compare with max x
		BLE clear_char
		ADD R1, R1, #1 // increment y by 1
		MOV R0, #0 // reset x to 0
		CMP R1, #60 // compare with max y
		BLE clear_char
		BX LR

@ TODO: insert PS/2 driver here.
read_PS2_data_ASM:
		push {R4, R5, R6, R7}
		LDR R4, =ps2_address // store address in R4
		LDR R5, [R4] // load value at address R4 in R5
		// the rvalid is at 16th bits
		MOV R6, #0x8000	// in hex
		AND R7, R6, R5 // and the value with R6 and store result in R7
		CMP R7, #1
		BEQ valid
		CMP R7, #0
		BEQ invalid

valid:
		MOV R6, #255 // last 8 bits
		AND R7, R6, R5
		STRB R7, [R0]
		MOV R0, #1	
		POP {R4, R5, R6, R7}
		BX LR

invalid:
		MOV R0, #0	
		POP {R4, R5, R6, R7}
		BX LR

write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}
	
	