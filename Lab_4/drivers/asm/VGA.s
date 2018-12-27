	.text
	.equ BASE_PIXEL, 0xC8000000
	.equ BASE_CHAR, 0xC9000000
	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM
	.global VGA_write_byte_ASM
	.global VGA_draw_point_ASM


VGA_clear_pixelbuff_ASM:
	PUSH {R0-R5}
	LDR R0, =BASE_PIXEL
	MOV R1, #0		// Count for x
	MOV R2, #0		// Count for y
	MOV R3, #0		// Black pixel
	MOV R5, R0		

PIXEL_X_LOOP:
	
	ADD R4, R5, R1, LSL #1	// Add the x-offset
	STRH R3, [R4]			// Insert black pixel

	ADD R1, R1, #1			// Increment x count
	
	CMP R1, #320			// At the last x positions branch to pixel_x_loop
	BLT PIXEL_X_LOOP
	

PIXEL_Y_LOOP:
	MOV R1, #0				// Reset the x position

	ADD R5, R0, R2, LSL #10	// Add the y-offset

	STRH R3, [R5]			// Store a black pixel
	
	CMP R2, #240			// At the last y position branch to pixel_y_loop
	ADD R2, R2, #1			// Increment y count
	BLT PIXEL_X_LOOP

PIXEL_CLEAR_END:			// Exit subroutine
	POP {R0-R5}
	BX LR

VGA_clear_charbuff_ASM:
	PUSH {R0-R5}
	LDR R0, =BASE_CHAR	
	MOV R1, #0			// X position
	MOV R2, #0			// Y position 
	MOV R3, #0 			// Null char
	MOV R5, R0

CHAR_X_LOOP:
	
	ADD R4, R5, R1		// Add the x-offset 
	STRB R3, [R4]		// Add null char

	ADD R1, R1, #1		// Increment the x count 
	
	CMP R1, #80			// At the last x position branch to char_x_loop
	BLT CHAR_X_LOOP
	

CHAR_Y_LOOP:
	MOV R1, #0				// Reset the x count 

	ADD R5, R0, R2, LSL #7	// Add the y-offset

	CMP R2, #60				// At the last y position branch to char_x_loop
	
	ADD R2, R2, #1			// Increment the y count
	BLT CHAR_X_LOOP

CHAR_CLEAR_END:				// Exit subroutine
	POP {R0-R5}
	BX LR


VGA_write_char_ASM:
	PUSH {R4 - R5}
	LDR R4, =BASE_CHAR
	
	CMP R0, #79				// If invalid input exit
	BGT END_WRITE_CHAR

	CMP R1, #59
	BGT END_WRITE_CHAR

	ADD R5, R4, R0			// Add the x-offset
	ADD R5, R5, R1, LSL #7	// Add the y-offset
	STRB R2, [R5]			// Store the char value 

END_WRITE_CHAR:				// Exit subroutine
	POP {R4 -R5}
	BX LR

VGA_write_byte_ASM:
	PUSH {R4-R5}

	CMP R0, #79				// If invalid exit
	BGT END_WRITE_BYTE

	CMP R1, #59
	BGT END_WRITE_BYTE

	LDR R4, =BASE_CHAR

	ADD R5, R4, R0			// Add the x-offset
	ADD R5, R5, R1, LSL #7	// Add the y-offset
	
	MOV R6, #0 				// count
	MOV R7, #1 				// Bit position
	MOV R8, #0 				// sum 
	MOV R9, #0 				// Lookup value 

	MOV R10, R2				// Load the input BYTE in R10
	LSR R10, R10, #4		// Load most significant HEX			

LOOP_1:
	CMP R6, #4				// If the loop has gone through the 4 bits, branch to RESET
	BGE RESET
	TST R10, R7				// Test if there is a 1 at bit position, if yes branch to SUM_1
	BGT SUM_1
	LSL R7, R7, #1			// Move bit positions 
	ADD R6, R6, #1			// Increment count
	B LOOP_1

SUM_1:
	ADD R8, R8, R7			// Add the sum bit position to total sum
	LSL R7, R7, #1			// Move bit positions
	ADD R6, R6, #1			// Increment count
	B LOOP_1

RESET:
	PUSH {LR}
	BL FIND_CHAR			// call the look up table subroutine
	POP {LR}
	MOV R10, R9				// Move lookup table value to R10
	MOV R6, #0 				// count
	MOV R7, #1 				// Bit position
	MOV R8, #0				// Reset the 

LOOP_2:
	CMP R6, #4				// If the loop has gone through the 4 bits, branch to DISPLAY
	BGE DISPLAY
	TST R2, R7				// Test if there is a 1 at bit position, if yes branch to SUM_2	
	BGT SUM_2
	LSL R7, R7, #1			// Move bit positions 
	ADD R6, R6, #1			// Increment count
	B LOOP_2

SUM_2:
	ADD R8, R8, R7			// Add the sum bit position to total sum
	LSL R7, R7, #1			// Move bit positions
	ADD R6, R6, #1			// Increment count
	B LOOP_2

DISPLAY:
	PUSH {LR}
	BL FIND_CHAR			// call the look up table subroutine
	POP {LR}
	MOV R4, R9				// Move the lookup value to R4
	STRB R10, [R5]			// Store the most significant HEX value
	ADD R5, R5, #1			// Move to the next address
	STRB R4, [R5]			// Store the least significant HEX value

END_WRITE_BYTE:				// Exit subroutine
	POP {R4-R5}
	BX LR
 
FIND_CHAR:				// Lookup table for HEX values 
	CMP R8, #0
	MOVEQ R9, #0x30
	CMP R8, #1
	MOVEQ R9, #0x31
	CMP R8, #2
	MOVEQ R9, #0x32
	CMP R8, #3
	MOVEQ R9, #0x33
	CMP R8, #4
	MOVEQ R9, #0x34
	CMP R8, #5
	MOVEQ R9, #0x35
	CMP R8, #6
	MOVEQ R9, #0x36
	CMP R8, #7
	MOVEQ R9, #0x37
	CMP R8, #8
	MOVEQ R9, #0x38
	CMP R8, #9
	MOVEQ R9, #0x39
	CMP R8, #10
	MOVEQ R9, #0x41
	CMP R8, #11
	MOVEQ R9, #0x42
	CMP R8, #12
	MOVEQ R9, #0x43
	CMP R8, #13
	MOVEQ R9, #0x44
	CMP R8, #14
	MOVEQ R9, #0x45
	CMP R8, #15
	MOVEQ R9, #0x46

	BX LR

VGA_draw_point_ASM:
	PUSH {R4 - R5}
	LDR R4, =BASE_PIXEL

	ADD R5, R4, R0, LSL #1		// Add the x-offset
	ADD R5, R5, R1, LSL #10		// Add the y-offset
	STRH R2, [R5]				// Store the pixel value 

	POP {R4 -R5}				// Exit subroutine
	BX LR

	.end