	.text
	.equ HEX_BASE1, 0xFF200020
	.equ HEX_BASE2, 0xFF200030
	.global HEX_clear_ASM
	.global HEX_flood_ASM
	.global HEX_write_ASM

HEX_flood_ASM:			
	PUSH {R1-R8}		// Pushes all of the used registers to the stack
	LDR R1, =HEX_BASE1	// Get location of HEX_DISPLAYS 0-3
	LDR R2, =HEX_BASE2	// Get location of HEX_DISPLAYS 4-5
	MOV R3, #0		// Initialize the counter to 0
	MOV R4, #1		// Initialize bit shift to 1
	MOV R5, #0		// Initialize to the first set of 8-bits
	
FIND_HEX_BASE_1_V1:
	CMP R3, #4		// If the HEX_DISPLAY index is past 3 then branch to FIND_HEX_BASE_2
	BGE FIND_HEX_BASE_2_V1	
	TST R0, R4		// Performs an AND operation and then sets the zero flag (Z = 1 at AND =1)
	BGT FLOOD_HEX_BASE_1	// If current HEX_DISPLAY is set to be on then flood
	LSL R4, R4, #1		// Shift to the next bit
	ADD R3, R3, #1		// Increment counter (for HEX_DISPLAY index)
	ADD R5, R5, #8		// Go to the next set of 8-bits
	B FIND_HEX_BASE_1_V1	// Iterate through the loop 

FIND_HEX_BASE_2_V1:
	CMP R3, #6		// If the HEX_DISPLAY index is past 5 then END
	BGE END
	TST R0, R4		// If current HEX_DISPLAY is set to be on then flood
	BGT FLOOD_HEX_BASE_2
	MOV R5, #40		// Set the bits to the 8 bits responsible for HEX_DISPLAY_5
	LSL R4, R4, #1		// Shift to the next bit
	ADD R3, R3, #1		// Increment the counter
	B FIND_HEX_BASE_2_V1	

END:
	POP {R1-R8} 		// Pops all of the used registers to the stack
	BX LR

FLOOD_HEX_BASE_1: 
	MOV R6, #127		// Insert the value for all of the segments to be on
	LDR R7, [R1]		// Load the current value in the HEX_DISPLAY_0-3 register
	LSL R6, R6, R5		// Shift the flood value  to the right set of 8-bits
	ORR R7, R7, R6		// Flood that set of segments
	STR R7, [R1]		// Store new value back to the HEX_DISPLAY_0-3 register
	LSL R4, R4, #1		// Shift to the next bit 
	ADD R3, R3, #1		// Increment the HEX_DISPLAY index 
	ADD R5, R5, #8		// Go to the next set of 8-bits
	B FIND_HEX_BASE_1_V1

FLOOD_HEX_BASE_2:
	MOV R6, #127		// Insert the value for all of the segments to be on
	LDR R7, [R2]		// Load the current value in the HEX_DISPLAY_4-5 register
	SUB R5, R5, #32		// Set the bit range back to the first 8 bits in the register
	LSL R6, R6, R5		// Shift the flood value to the right set of 8-bits
	ORR R7, R7, R6		// Flood that set of sgements
	STR R7, [R2]		// Store the new value back to the HEX_DISPLAY_4-5
	LSL R4, R4, #1		// Shift to the next bit 
	ADD R3, R3, #1		// Increment the HEX_DISPLAY index
	MOV R5, #40		// Go to the next set of 8-bits
	B FIND_HEX_BASE_2_V1





HEX_clear_ASM:
	PUSH {R1-R8}		// Pushes all of the arguements to the stack
	LDR R1, =HEX_BASE1	// Get location of HEX_DISPLAYS 0-3
	LDR R2, =HEX_BASE2  // Get location of HEX_DISPLAYS 4-5
	MOV R3, #0          // Initialize the counter to 0
	MOV R4, #1          // Initialize bit shift to 1
	MOV R5, #56         // Initialize to the last se

FIND_HEX_BASE_1_V2:
	CMP R3, #4
	BGE FIND_HEX_BASE_2_V2
	TST R0, R4
	BGT CLEAR_HEX_BASE_1
	LSL R4, R4, #1
	ADD R3, R3, #1
	SUB R5, R5, #8
	B FIND_HEX_BASE_1_V2

FIND_HEX_BASE_2_V2:
	CMP R3, #6
	BGE END
	TST R0, R4
	BGT CLEAR_HEX_BASE_2
	MOV R5, #16
	LSL R4, R4, #1
	ADD R3, R3, #1
	B FIND_HEX_BASE_2_V2

CLEAR_HEX_BASE_1: 
	MOV R6, #0X00FFFFFF
	LDR R7, [R1]
	ROR R6, R6, R5
	AND R7, R7, R6
	STR R7, [R1]
	
	LSL R4, R4, #1
	ADD R3, R3, #1
	SUB R5, R5, #8
	B FIND_HEX_BASE_1_V2

CLEAR_HEX_BASE_2:
	MOV R6, #0X00FFFFFF
	LDR R7, [R2]
	ADD R5, R5, #32
	ROR R6, R6, R5
	AND R7, R7, R6
	STR R7, [R2]
	
	LSL R4, R4, #1
	ADD R3, R3, #1
	MOV R5, #16
	B FIND_HEX_BASE_2_V2





HEX_write_ASM:
	PUSH {R2-R8}
	LDR R2, =HEX_BASE1
	LDR R3, =HEX_BASE2
	MOV R4, #0
	MOV R5, #1
	MOV R6, #0
	MOV R10, #56

FIND_CHAR:			//Map of all of the HEX value
	CMP R1, #0
	MOVEQ R9, #63
	CMP R1, #1
	MOVEQ R9, #6
	CMP R1, #2
	MOVEQ R9, #91
	CMP R1, #3
	MOVEQ R9, #79
	CMP R1, #4
	MOVEQ R9, #102
	CMP R1, #5
	MOVEQ R9, #109
	CMP R1, #6
	MOVEQ R9, #125
	CMP R1, #7
	MOVEQ R9, #7
	CMP R1, #8
	MOVEQ R9, #127
	CMP R1, #9
	MOVEQ R9, #103
	CMP R1, #10
	MOVEQ R9, #119
	CMP R1, #11
	MOVEQ R9, #124
	CMP R1, #12
	MOVEQ R9, #57
	CMP R1, #13
	MOVEQ R9, #94
	CMP R1, #14
	MOVEQ R9, #121
	CMP R1, #15
	MOVEQ R9, #113


FIND_HEX_BASE_1_V3:
	CMP R4, #4
	BGE FIND_HEX_BASE_2_V3
	TST R0, R5
	BGT WRITE_HEX_BASE_1
	LSL R5, R5, #1
	ADD R4, R4, #1
	ADD R6, R6, #8
	SUB R10, R10, #8
	B FIND_HEX_BASE_1_V3

FIND_HEX_BASE_2_V3:
	CMP R4, #6
	BGE END_WRITE
	TST R0, R5
	BGT WRITE_HEX_BASE_2
	MOV R6, #40
	MOV R10, #16
	LSL R5, R5, #1
	ADD R4, R4, #1
	B FIND_HEX_BASE_2_V3

WRITE_HEX_BASE_1:
	MOV R7, #0X00FFFFFF
	LDR R8, [R2]
	ROR R7, R7, R10
	AND R8, R8, R7
	STR R8, [R2]

	MOV R7, R9
	LDR R8, [R2]
	LSL R7, R7, R6
	ORR R8, R8, R7
	STR R8, [R2]

	LSL R5, R5, #1
	ADD R4, R4, #1
	ADD R6, R6, #8
	SUB R10, R10, #8
	B FIND_HEX_BASE_1_V3

WRITE_HEX_BASE_2:
	MOV R7, #0X00FFFFFF
	LDR R8, [R3]
	SUB R6, R6, #32
	ADD R10, R10, #32
	ROR R7, R7, R10
	AND R8, R8, R7
	STR R8, [R3]

	MOV R7, R9
	LDR R8, [R3]
	LSL R7, R7, R6
	ORR R8, R8, R7
	STR R8, [R3]

	LSL R5, R5, #1
	ADD R4, R4, #1
	MOV R10, #16
	MOV R6, #40
	B FIND_HEX_BASE_2_V3

END_WRITE:
	POP {R2-R8} 
	BX LR
	.end
