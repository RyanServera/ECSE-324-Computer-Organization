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
	LDR R1, =KEY_BASE       // Load the KEY_BASE address
	LDR R0, [R1]            // Return the current value in it
	BX LR

PB_data_is_pressed_ASM:
	PUSH { R1-R2}
	LDR R1, =KEY_BASE       // Load the KEY_BASE address
	LDR R2, [R1]            // Load the current value of the address
	TST R2, R0              // Perform an AND on it with input
	MOVGT R0, #1            // If the button is pressed return 1
	MOVEQ R0, #0            // Else return 0
	POP {R1-R2}
	BX LR 

read_PB_edgecap_ASM:
	LDR R1, = EDGE_CAPTURE_BASE // Load the EDGE_CAPTURE_BASE address
	LDR R0, [R1]                // Return its current value
	BX LR

PB_edgecap_is_pressed_ASM:
	PUSH { R1-R2 }
	LDR R1, = EDGE_CAPTURE_BASE // Load the EDGE_CAPTURE_BASE address
	LDR R2, [R1]                // Load it to R2
	TST R2, R0                  // Perform an AND on it with input
	MOVGT R0, #1                // If the button is triggered then return 1
	MOVEQ R0, #0                // else return 0
	POP {R1-R2}
	BX LR 

PB_clear_edgecap_ASM:
	PUSH { R1-R2 }
	LDR R1, = EDGE_CAPTURE_BASE // Load the EDGE_CAPTURE_BASE address
	MOV R2, #0xf                // Insert 1111(b)
	STR R2, [R1]                // Clear EDGE_CAPTURE by storing something that is not 0 to every bit
	POP {R1-R2}
	BX LR

enable_PB_INT_ASM:
	PUSH { R1-R2 }
	LDR R1, = INTERRUPT_MASK_BASE   // Load the INTERRUPT_MASK_BASE address
	AND R2, R0, #0xf                // Check which inputs need to be on
	STR R2, [R1]                    // enable the interrupt
	POP {R1-R2}
	BX LR 

disable_PB_INT_ASM:
	PUSH { R1-R2 }
	LDR R1, = INTERRUPT_MASK_BASE   // Load the INTERRUPT_MASK_BASE address
	MVN R0, R0                      // Complement the inputs (0 to all of the pushbutton that want to have interrupt disabled)
	AND R2, R0, #0xf                // inputs are now 0
	STR R2, [R1]                    // Disable the interrupt on the inputs
	POP {R1-R2}
	BX LR 

.end 
