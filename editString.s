/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : editString.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts four arguments: headPtr (R0), # Nodes (R1), Index (R2), and 
 * string (R3). It replaces the string at the given index with the given string. And
 * returns the # of bytes in the original string in r0 and # of bytes of new string in r1.
 *	R0: Pointer to head of linked list
 *	R1: Number of nodes in the linked list
 *	R2: Index of string to replace (position in linked list)
 *	R3: Address of string to replace the one at the given index
 *	LR: Return address
 * Returns:
 *	R0: # bytes of original string
 *	R1: # bytes of new string
 * AAPCS Compliant
 ****************************************************************************************/

.data					@ Directive for the initialized data section

iTempEdit:	.word 0			@ NULL pointer used for a temp variable used for editing

.text					@ Directive for the text section
	.global editString		@ Provides subroutine starting address to linker
	.extern free			@ Using extern directive to provide assembler with free c function
	
editString:				@ Label for the start of the edit subroutine
	push 	{r4-r8, r10, r11, lr}	@ Pushes AAPCS Registers and LR

	ldr	r4, =iTempEdit		@ Loads iTempEdit address into r4
	str 	r0, [r4]		@ Stores headPtr into iTempEdit
	mov	r6, r1			@ Loads # nodes into r6
	mov	r10, r3			@ Loads address of string into r10
	mov	r11, r2			@ Loads index to find in r11
	mov 	r5, #0			@ Starts counter (index)

loop_edit:				@ Loop for finding the appropriate string to edit
	cmp 	r5, r6			@ If # of nodes == current index
	beq 	end_edit		@ Branch to end (end of list)
	
	cmp	r5, r11			@ If current index == given index
	beq	index_found		@ Branch to index_found to replace string in node

	ldr 	r8, [r4]		@ Loads pointer to current node into r8
	ldr 	r7, [r8, #4]		@ Move to point to head of next node
	str 	r7, [r4]		@ Dereference to get head of next node
	
	cmp 	r7, #0			@ If ptr == NULL
	beq 	end_edit		@ End of List, branch to end
	
	add 	r5, #1			@ Increment index by 1
	b 	loop_edit		@ Continue looping

index_found:				@ Label for editing once the string is found
	ldr 	r8, [r4]		@ Loads pointer to current node into r8
	ldr 	r0, [r8]		@ Dereferences to get address of string in node
	bl	String_Length		@ Gets length of original string
	add	r0, #1			@ Adds 1 for NULL
	mov	r4, r0			@ Return # bytes of original string

	ldr	r0, [r8]		@ Loads string address
	bl	free			@ Deallocates the memory for this string

	mov	r0, r10			@ Moves given string

	bl	String_copy		@ Copies string (allocating memory for it)
	str	r0, [r8]		@ Stores copy into current node

	bl	String_Length		@ Gets length of new string
	add	r0, #1			@ Adds 1 for NULL
	mov	r2, r0			@ Return # bytes of new string

	mov	r0, r4			@ Move into r0 the # of bytes of the original string
	mov	r1, r2			@ Move into r1 the # of bytes of the new string	
	
end_edit:				@ Label for the end of the edit subroutine
	pop 	{r4-r8, r10, r11, lr}	@ Pop APPCS and LR registers (restores)
	bx 	lr			@ Return to caller
