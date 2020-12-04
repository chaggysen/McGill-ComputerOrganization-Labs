.global _start
_start:
		.equ pixel_buffer, 0xC8000000 // pixel buffer
		.equ char_buffer, 0xc9000000 // char buffer
        bl      draw_test_screen
end:
        b       end

@ TODO: Insert VGA driver functions here.

// draw a point at a specific color
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

draw_test_screen:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r6, #0
        ldr     r10, .draw_test_screen_L8
        ldr     r9, .draw_test_screen_L8+4
        ldr     r8, .draw_test_screen_L8+8
        b       .draw_test_screen_L2
.draw_test_screen_L7:
        add     r6, r6, #1
        cmp     r6, #320
        beq     .draw_test_screen_L4
.draw_test_screen_L2:
        smull   r3, r7, r10, r6
        asr     r3, r6, #31
        rsb     r7, r3, r7, asr #2
        lsl     r7, r7, #5
        lsl     r5, r6, #5
        mov     r4, #0
.draw_test_screen_L3:
        smull   r3, r2, r9, r5
        add     r3, r2, r5
        asr     r2, r5, #31
        rsb     r2, r2, r3, asr #9
        orr     r2, r7, r2, lsl #11
        lsl     r3, r4, #5
        smull   r0, r1, r8, r3
        add     r1, r1, r3
        asr     r3, r3, #31
        rsb     r3, r3, r1, asr #7
        orr     r2, r2, r3
        mov     r1, r4
        mov     r0, r6
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        add     r5, r5, #32
        cmp     r4, #240
        bne     .draw_test_screen_L3
        b       .draw_test_screen_L7
.draw_test_screen_L4:
        mov     r2, #72
        mov     r1, #5
        mov     r0, #20
        bl      VGA_write_char_ASM
        mov     r2, #101
        mov     r1, #5
        mov     r0, #21
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #22
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #23
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #24
        bl      VGA_write_char_ASM
        mov     r2, #32
        mov     r1, #5
        mov     r0, #25
        bl      VGA_write_char_ASM
        mov     r2, #87
        mov     r1, #5
        mov     r0, #26
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #27
        bl      VGA_write_char_ASM
        mov     r2, #114
        mov     r1, #5
        mov     r0, #28
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #29
        bl      VGA_write_char_ASM
        mov     r2, #100
        mov     r1, #5
        mov     r0, #30
        bl      VGA_write_char_ASM
        mov     r2, #33
        mov     r1, #5
        mov     r0, #31
        bl      VGA_write_char_ASM
        pop     {r4, r5, r6, r7, r8, r9, r10, pc}
.draw_test_screen_L8:
        .word   1717986919
        .word   -368140053
        .word   -2004318071
	
	