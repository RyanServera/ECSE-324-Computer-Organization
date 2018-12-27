.text
		.global _start

_start:	LDR R6, =RESULT
		LDR R0, [R6, #4]

PUSH_FUNC: 	STR R0, [SP, #-4]!

POP_FUNC:	LDR R2, [SP], #4

RESULT: .word 0
NUMBER: .word 20
