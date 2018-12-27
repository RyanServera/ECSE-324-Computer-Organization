			.text
			.global _start

_start:
			LDR R9, =N					//points to address of length of array
			LDR R2,	[R9]				//holds length of array
			LDR R8, =NUMBERS			//holds address of first number
			MOV R1, #-1					//holds boolean to check if should stay in while loop
										//false = -1, true = 1

WHILE:		ADD R1, #1					//add 1
			SUBS R1, #1					//subtract 1
			BGE END						//array is solved, exit the loop
			MOV R0, #1					//load 1 into register
			MOV R1, #1					//sorted=true

FOR:		CMP R0, R2					//check if index is greater than number of elements
			BGE WHILE					//index has reached the end of for loop
			LDR R3, [R8, R0, LSL #2]	//load array[i]
			SUBS R5, R0, #1				//subs 1 from index
			LDR R4, [R8, R5, LSL #2]	//load array[i-1]
			CMP R3, R4					//compare the two 
			BGE SECOND_FOR				//next for loop iteration
			STR R4, [R8, R0, LSL #2]	//store flip
			STR R3, [R8, R5, LSL #2]	//store flip
			MOV R1, #-1					//make sorted boolean false
			B SECOND_FOR				//next for loop iteration
		

SECOND_FOR:		ADD R0, R0, #1			//increment index
			B FOR						//back to top of for loop


END:		B END						//end (or infinite loop)


N:			.word	12					//length of array
NUMBERS:	.word	45, 7, 3, 6			//numbers to be sorted
			.word	1, 8, 21, 12
			.word	100, 6, 90, 4	
