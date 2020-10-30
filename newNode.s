/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : newNode.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts three arguments: head (R1), tail (R2), data (r3). It
 * Creates a new node in the linked list for the data passed through.
 *	R1: Current head ptr
 *	R2: Current tail ptr
 *	R3: Data to be added to list
 *	LR: Return address
 * Returns:
 *	R1: Updated head ptr
 *	R2: Updated tail ptr
 * AAPCS Compliant
 ****************************************************************************************/

.text					@ Directive for the text section
	.global newNode			@ Provides subroutine starting address to linker
	.extern malloc			@ Using extern directive to provide assembler with malloc c function

newNode:				@ Label for the start of the newNode subroutine
	push 	{r4-r8, r10, r11, lr}	@ Pushes AAPCS and LR registers

	mov 	r0, #8			@ Move 8 into r0 for the node
	push 	{r1-r3}			@ Push r1-r3 to preserve values
	bl 	malloc			@ Allocate memory for 8 bytes for the node
	pop 	{r1-r3} 		@ Pop r1-r3 to restore values

	str 	r3, [r0]		@ Stores r3 in first 4 bytes of dynamic memory

	mov 	r4, #0			@ Moves 0 into r4
	str 	r4, [r0, #4]		@ Loads 0 (NULL) into last 4 bytes (nextPtr)

	cmp 	r1, #0			@ If head == NULL
	moveq 	r1, r0			@ Load start of node to head (if equal)
	beq 	endNewNode		@ Branch to end (if equal)
	
	str 	r0, [r2, #4]		@ Else, Store r0 in tail

endNewNode:				@ Label for the end of the newNode subroutine
	mov 	r2, r0			@ Load new tail into r2 to be returned

	pop 	{r4-r8, r10, r11, lr}	@ Pops AAPCS registers and LR (restores)
	bx	lr			@ Return to caller

