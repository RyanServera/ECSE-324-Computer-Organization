.text
		.global _start

_start:
			LDR R4, =RESULT		// Load memory address of RESULT
			LDR R2, [R4, #4]	// Initialize counter to array length
			ADD R3, R4, #8		// Load memory address of first element in array
			LDR R0, [R3]		// Load value of first element of the array

LOOP:		SUBS R2, R2, #1		// Decrement counter
			BEQ DONE			// Go to DONE when counter = 0
			ADD R3, R3, #4		// Load the memory adrress of the next array element
			LDR R1, [R3]		// Load the value of the next array element 
			CMP R0, R1			// Compare the value of two array element
			BGE LOOP			// Iterate through the loop
			MOV R0, R1			// If next is bigger than current replace RESULT value
			B LOOP				// Iterate through the loop

DONE:		STR R0, [R4]		// Store the RESULT value

END:		B END				// end (infinite loop)

RESULT:		.WORD 0				// Max value
N:			.WORD 7				// Length of the array
NUMBERS:	.WORD 4, 5, 3, 6	// Numbers in the array
			.WORD 1, 8, 2	
