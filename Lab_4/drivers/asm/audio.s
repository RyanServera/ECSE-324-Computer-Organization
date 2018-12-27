	.text
	.equ left_channel, 0xFF203048
	.equ right_channel, 0xFF20304C
	.equ fifospace, 0xFF203044
	.global audio_write_ASM

audio_write_ASM:
			PUSH {R4-R5}	//push register contents to stack
			LDR R1, =left_channel	//load addresses of left_channel and right_channel regs
			LDR R2, =right_channel
			LDR R3, =fifospace
			LDRB R4, [R3,#2]	//value of WSRC into R4
			LDRB R5, [R3, #3]	//WSLC into R5

CHECK_VALID:
			CMP R4, #0	//check if fifos == full
			BEQ INVALID
			CMP R5, #0	//same as above
			BEQ INVALID

END_AUDIO:
			STR R0, [R1]	//if fifos != full, store data in fifo
			STR R0, [R2]
			MOV R0, #1	//and return 1
			POP {R4-R5}
			BX LR

INVALID:
			MOV R0, #0
			POP {R4-R5}
			BX LR
