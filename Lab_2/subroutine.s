.text
	.global MAX_2

MAX_2:
		CMP R0, R1		// compare two numbers 
		BXGE LR		// if R0 is bigger don't swap
		MOV R0, R1		// else swap 
		BX LR			
.end
