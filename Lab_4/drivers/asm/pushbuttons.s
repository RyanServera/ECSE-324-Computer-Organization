	.text
	.equ KEY_BASE, 0xFF200050
	.equ EDGE_CAPTURE_BASE, 0xFF20005C
	.equ INTERRUPT_MASK_BASE, 0xFF200058
	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM
	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM
	.global hps_tim0_int_flag


read_PB_data_ASM:
	LDR R1, =KEY_BASE
	LDR R0, [R1]
	BX LR

PB_data_is_pressed_ASM:
	PUSH { R1-R2}
	LDR R1, =KEY_BASE
	LDR R2, [R1]
	TST R2, R0
	MOVGT R0, #1
	MOVEQ R0, #0
	POP {R1-R2}
	BX LR 

read_PB_edgecap_ASM:
	LDR R1, = EDGE_CAPTURE_BASE
	LDR R0, [R1]
	BX LR

PB_edgecap_is_pressed_ASM:
	PUSH { R1-R2 }
	LDR R1, = EDGE_CAPTURE_BASE
	LDR R2, [R1]
	TST R2, R0
	MOVGT R0, #1
	MOVEQ R0, #0
	POP {R1-R2}
	BX LR 

PB_clear_edgecap_ASM:
	PUSH { R1-R2 }
	LDR R1, = EDGE_CAPTURE_BASE
	MOV R2, #0xf
	STR R2, [R1]
	POP {R1-R2}
	BX LR

enable_PB_INT_ASM:
	PUSH { R1-R2 }
	LDR R1, = INTERRUPT_MASK_BASE
	AND R2, R0, #0xf
	STR R2, [R1]
	POP {R1-R2}
	BX LR 

disable_PB_INT_ASM:
	PUSH { R1-R2 }
	LDR R1, = INTERRUPT_MASK_BASE
	MVN R0, R0
	AND R2, R0, #0xf
	STR R2, [R1]
	POP {R1-R2}
	BX LR 

.end 
