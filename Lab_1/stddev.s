.text
		.global _start

_start:
		LDR R4, =MAX		// Load memory address of MAX	
		LDR R2, [R4, #12]	// Initialize counter to array length
		ADD R3, R4, #16		// Load memory address of first element in array
		LDR R0, [R3]		// Load value of first element of the array

LOOP1:	SUBS R2, R2, #1		// Decrement counter
		BEQ PART2			// Go to PART2 when counter = 0
		ADD R3, R3, #4		// Load the memory adrress of the next array element
		LDR R1, [R3]		// Load the value of the next array element 
		CMP R0, R1			// Compare the value of two array element
		BGE LOOP1			// Iterate through the loop
		MOV R0, R1			// If next is bigger than current replace MAX value
		B LOOP1				// Iterate through the loop

PART2:	STR R0, [R4]		// Store the MAX value
		LDR R5, =MIN		// Load memory address of MIN
		LDR R2, [R5, #8]	// Initilize counter to array length
		ADD R3, R5, #12		// Load memory address of first element in array
		LDR R0, [R3]		// Load the value of first element of the array

LOOP2:	SUBS R2, R2, #1		// Decrement Counter
		BEQ STD_DIV			// Go to STD_DIV when the counter = 0
		ADD R3, R3, #4		// Load the memory address of the next array element
		LDR R1, [R3]		// Load the value of the next array element
		CMP R0, R1			// Compare the value of two array element
		BLE LOOP2			// Iterate through the loop
		MOV R0, R1			// If next is smaller than current replace MIN value
		B LOOP2				// Iterate through the loop

STD_DIV:	
		STR R0, [R5]		// Store the MIN value
		LDR R6, =FINAL		// Load memory address of final value
		LDR R4, [R4]		// Load the value of MAX
		LDR R5, [R5]		// Load the value of MIN 
		SUB R6, R4, R5		// Substract MAX value and MIN value
		B DONE				// Go to DONE

DONE:	LSR R0, R6, #2		// Divide and store the final result

END:	B END				// end (infinite loop)

MAX:	.WORD 0				// Max value
MIN:	.WORD 0				// Min value
FINAL:	.WORD 0				// Final value
N:		.WORD 7				// Length of the array
NUMBERS:.WORD 0, 5, 3, 6	// Numbers in the array
		.WORD 7, 12, 4