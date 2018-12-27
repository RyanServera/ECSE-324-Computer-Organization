	.text
	.equ LED_BASE, 0xFF200000
	.global read_LEDs_ASM
	.global write_LEDs_ASM

read_LEDs_ASM:
	LDR R1, =LED_BASE   // Load the memory address of the LED_BASE
	LDR R0, [R1]        // Return its current value
	BX LR

write_LEDs_ASM:
	LDR R1, =LED_BASE   // Load the memory address of the LED_BASE
	STR R0, [R1]        // Set the bits to 1 for the given inputs
	BX LR

	.end
