	.text
	.equ left_channel, 0xFF203048
	.equ right_channel, 0xFF20304C
	.equ fifospace, 0xFF203044
	.global audio_write_ASM

audio_write_ASM:
			PUSH {R4-R8}	//push register contents to stack
			LDR R4, =left_channel	//load addresses of left_channel and right_channel regs
			LDR R5, =right_channel
			LDR R6, =fifospace
			LDRB R7, [R6,#2]	//value of WSRC into R4
			LDRB R8, [R6, #3]	//WSLC into R5

CHECK_VALID:
			CMP R7, #0	//check if fifos == full
			BEQ INVALID
			CMP R8, #0	//same as above
			BEQ INVALID

END_AUDIO:
			STR R0, [R4]	//if fifos != full, store data in fifo
			STR R0, [R5]
			MOV R0, #1	//and return 1
			POP {R4-R8}
			BX LR

INVALID:
			MOV R0, #0
			POP {R4-R8}
			BX LR
