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
	BL uart_init
	BL read_string
	BL output_string

	POP {lr}	  ; Restore lr from stack
	mov pc, lr

; Part #2
read_string: ;Zayed
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
	MOV r2, #0xC000  	;load first 16 bits to r2
	MOVT r2, #0x4000 	;load second 16 bits to get 0x4000C000
Loop1:
	LDRB r1, [r0, #U0FR] ;load the UART0 flag register
	AND r1, r1, #0x20	 ; Mask the 5th bit
	CMP r1, #0x20		 ; see if it is equal to 1
	BEQ Loop1			 ; if yes then loop back to loop1
	STRB r0, [r2]		 ; if not store the value in r0 to the data register

	POP {lr}
	mov pc, lr



read_character:
	PUSH {lr}   ; Store register lr on stack

		; Your code to receive a character obtained from the keyboard
		; in PuTTy is placed here.  The character is received in r0.
	MOV r0, #0xC000	 ; load first 16 bits to r2
	MOVT r0, #0x4000 ; load second 16 bits to get 0x4000C000
Loop:
	LDRB r1, [r0, #U0FR] ;load the UART0 flag register
	AND r1, r1, #0x10	 ; Mask the 5th bit
	CMP r1, #0x10		 ; see if it is equal to 1
	BEQ Loop			 ; if yes then loop back to loop
	LDRB r0, [r0]		 ; if no then load the data in the data register to r0

	POP {lr}
	mov pc, lr

; Part #2
uart_init:
	PUSH {lr}  ; Store register lr on stack

	; Your code for your uart_init routine is placed here
    (*((volatile uint32_t *)(0x400FE618))) = 1;
    MOV r2, 0xE618
    MOVT r2, 0x400F
    MOV r3, #1
    STRB r3, [r2]

    /* Enable clock to PortA  */
    (*((volatile uint32_t *)(0x400FE608))) = 1;
    MOV r2, 0xE608
    MOVT r2, 0x400F
    MOV r3, #1
    STRB r3, [r2]

    /* Disable UART0 Control  */
    (*((volatile uint32_t *)(0x4000C030))) = 0;
    MOV r2, 0xC030
    MOVT r2, 0x4000
    MOV r3, #0
    STRB r3, [r2]

    /* Set UART0_IBRD_R for 115,200 baud */
    (*((volatile uint32_t *)(0x4000C024))) = 8;
    MOV r2, 0xC024
    MOVT r2, 0x4000
    MOV r3, #8
    STRB r3, [r2]

    /* Set UART0_FBRD_R for 115,200 baud */
    (*((volatile uint32_t *)(0x4000C028))) = 44;
    MOV r2, 0xC028
    MOVT r2, 0x4000
    MOV r3, #44
    STRB r3, [r2]

    /* Use System Clock */
    (*((volatile uint32_t *)(0x4000CFC8))) = 0;
    MOV r2, 0xCFC8
    MOVT r2, 0x4000
    MOV r3, #0
    STRB r3, [r2]

    /* Use 8-bit word length, 1 stop bit, no parity */
    (*((volatile uint32_t *)(0x4000C02C))) = 0x60;
    MOV r2, 0xC02C
    MOVT r2, 0x4000
    MOV r3, #0x60
    STRB r3, [r2]

    /* Enable UART0 Control  */
    (*((volatile uint32_t *)(0x4000C030))) = 0x301;
    MOV r2, 0xC030
    MOVT r2, 0x4000
    MOV r3, #0x301
    STRB r3, [r2]
        /*************************************************/
    /* The OR operation sets the bits that are OR'ed */
    /* with a 1.  To translate the following lines   */
    /* to assembly, load the data, OR the data with  */
    /* the mask and store the result back.           */
        /*************************************************/
    /* Make PA0 and PA1 as Digital Ports  */
    (*((volatile uint32_t *)(0x4000451C))) |= 0x03; /* store (0x4000451C OR 0x03) in 0x4000451C*/
    MOV r2, 0x451C
    MOVT r2, 0x4000
    MOV r3, #0x03
    LDRB r1, [r2]
    ORR r1, r1, r3
    STRB r1, [r2]

    /* Change PA0,PA1 to Use an Alternate Function  */
    (*((volatile uint32_t *)(0x40004420))) |= 0x03;
    MOV r2, 0x4420
    MOVT r2, 0x4000
    MOV r3, #0x03
    LDRB r1, [r2]
    ORR r1, r1, r3
    STRB r1, [r2]

    /* Configure PA0 and PA1 for UART  */
    (*((volatile uint32_t *)(0x4000452C))) |= 0x11;
    MOV r2, 0x452C
    MOVT r2, 0x4000
    MOV r3, #0x11
    LDRB r1, [r2]
    ORR r1, r1, r3
    STRB r1, [r2]


	POP {lr}
	mov pc, lr

int2string: ;Zayed
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
