			.text
			.global _start

_start:
			LDR R0, =NFIB		//R0 points to the address which fib we want
			LDR R0,	[R0]		//load actual value of wanted fib
			PUSH {LR}			//push LR assuming we are called by a higher order function
			PUSH {R0}			//arguments pushed on the stack
			BL FIB  			//call subroutine of fib
			POP {R1}			//R1 is answer
			POP {LR}			//pop linked register back to caller
			LDR R2, =ANSWER  	//address of answer		
			STR R1, [R2]		//store out answer value
			B END	

FIB: 			PUSH {R0 - R3} 		//push all the arguments on the stack so we don't lose information (higher order function)
			LDR R0, [SP, #16]	//load argument
			CMP R0, #3			//see if value is less than 3
			BMI BASE_CASE		//check for negative flag
			SUB R0, R0, #1		//gets fib(n-1)
			PUSH {LR}
			PUSH {R0}
			BL FIB
			POP {R1}			//pop answer into r1 from fib(n-1)
			SUB R0, R0 , #1		//gets fib(n-2)
			PUSH {R0}
			BL FIB
			POP {R2}			//pop answer into r2 from fib(n-2)
			POP {LR}			//same lr to return to caller (because over-written 3 lines ago)
			ADD R3, R1, R2		//R3 = fib(n) = fib(n-1) + fib(n-2)	

RETURNFIB:  	STR R3, [SP, #16]	//store actual result on stack where OG argument was
			POP {R0 - R3}		//go back to caller with OG register contents
			BX LR
			
BASE_CASE:		MOV R3, #1			//moves content of 1 in the register
			B RETURNFIB
			

END:			B END				//infinite loop


NFIB:			.word	20			//fib value to calculate
ANSWER:		.space	4   		//make space 