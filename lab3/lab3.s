	.data

	.global prompt
	.global results
	.global num_1_string
	.global num_2_string

prompt:	.string "Your prompts are placed here", 0
result:	.string "Your results are reported here", 0
num_1_string: 	.string "Place holder string for your first number", 0
num_2_string:  	.string "Place holder string for your second number", 0

	.text

	.global lab3
U0FR: 	.equ 0x18	; UART0 Flag Register

ptr_to_prompt:		.word prompt
ptr_to_result:		.word result
ptr_to_num_1_string:	.word num_1_string
ptr_to_num_2_string:	.word num_2_string

lab3:
	PUSH {lr}   ; Store lr to stack
	ldr r4, ptr_to_prompt
	ldr r5, ptr_to_result
	ldr r6, ptr_to_num_1_string
	ldr r7, ptr_to_num_2_string

		; Your code is placed here.  This is your main routine for
		; Lab #3.  This should call your other routines such as
		; uart_init, read_string, output_string, int2string, &
		; string2int

	POP {lr}	  ; Restore lr from stack
	mov pc, lr

; Part #2
read_string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your read_string routine is placed here

	POP {lr}
	mov pc, lr


output_string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your output_string routine is placed here

	POP {lr}
	mov pc, lr

; Part #2 ^^

output_character:
	PUSH {lr}   ; Store register lr on stack

		; Your code to output a character to be displayed in PuTTy
		; is placed here.  The character to be displayed is passed
		; into the routine in r0.
	MOV r2, #0xC000  ; load first 16 bits to r2
	MOVT r2, #0x4000 ; load second 16 bits to get 0x4000C000
Loop1:
	LDRB r1, [r0, #U0FR]
	AND r1, r1, #0x20
	CMP r1, #0x20
	BEQ Loop1
	STRB r0, [r2]

	POP {lr}
	mov pc, lr



read_character:
	PUSH {lr}   ; Store register lr on stack

		; Your code to receive a character obtained from the keyboard
		; in PuTTy is placed here.  The character is received in r0.
	MOV r0, #0xC000	 ; load first 16 bits to r2
	MOVT r0, #0x4000 ; load second 16 bits to get 0x4000C000
Loop:
	LDRB r1, [r0, #U0FR] ; load the
	AND r1, r1, #0x10
	CMP r1, #0x10
	BEQ Loop

	LDRB r0, [r0]

	POP {lr}
	mov pc, lr

; Part #2
uart_init:
	PUSH {lr}  ; Store register lr on stack

		; Your code for your uart_init routine is placed here

	POP {lr}
	mov pc, lr

int2string:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your int2string routine is placed here

	POP {lr}
	mov pc, lr


string2int:
	PUSH {lr}   ; Store register lr on stack

		; Your code for your string2int routine is placed here

	POP {lr}
	mov pc, lr

	.end

	.end
