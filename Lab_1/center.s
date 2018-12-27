.text
		.global _start

_start:
			LDR R9, =N                   // Load the memory address of the array length
			LDR R2, [R9]                 // Initialize the counter to array length
			LDR R8, =NUMBERS             // Load the the first memory address of the array
			LDR R4, =SUM                 // Load the memory address of the sum
			MOV R1, #0                   // Set index buffer to 0
			LDR R6, [R4]                 // Set sum buffer to 0 (initial value)
			
			
FOR:		BEQ AVERAGE                  // Branch to average when counter = 0
			LDR R5,[R8, R1, LSL #2]      // Load array[i]
			ADD R6, R6, R5               // Add array[i] to the sum
			ADD R1, R1, #1               // Increment the index buffer
			SUBS R2, R2, #1              // Decrement the counter
			B FOR                        // Iterate through the loop
			

AVERAGE:	STR R6, [R4]                 // Store the sum in the value of R4
			LSR R0, R6, #3               // Find the average 
			LDR R2, [R9]                 // Reset the counter
			ADDS R1, R1, #1              // Reset Status Register
			MOV R1, #0                   // Reset the index buffer
			B SECOND_FOR                 // Go to the second for loop


SECOND_FOR:	BEQ END                      // Terminate program
			LDR R5,[R8, R1, LSL #2]      // Load array[i]
			SUB R5, R5, R0               // Substract the value of array[i] with the average
			STR R5, [R8, R1, LSL #2]     // Store the centered result in array[i]
			ADD R1, R1, #1               // Increment the array index
			SUBS R2, R2, #1              // Decrement the loop counter
			B SECOND_FOR                 // Iterate through the loop

END:		B END				         // End (or infinite loop)


SUM:		.word	0                    // Sum of all 
N:			.word	8			         // Length of array
NUMBERS:	.word	1, 2, 8, 9		     // Numbers to be sorted
			.word	10, 4, 24, 6
