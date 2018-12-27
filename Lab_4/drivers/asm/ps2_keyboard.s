	.text
	.equ PS2_data, 0xFF200100
	.global read_PS2_data_ASM

read_PS2_data_ASM:
			LDR R4, =PS2_data	//load the ps/2 data register address into R4
			LDR R7, [R4]

CHECK_VALID:		    
			MOV R8, #0x8000
			AND R5, R7, R8
			CMP R5, #0	//check if RVALID = 1
			MOVEQ R0, #0	//return 0
			BXEQ LR

END_PS2:
			STRB R7, [R0]	//read and place data at address in pointer
			MOV R0, #1	//return 1
			BX LR
