/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : displayList.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts two arguments: headPtr (R0), # Nodes (R1). Traverses through
 * the linked list, printing all the strings in the linked list
 *	R0: Pointer to head of linked list
 *	R1: Number of nodes in the linked list
 *	LR: Return address
 * Returns:
 *	None
 * AAPCS Compliant
 ****************************************************************************************/

.data					@ Directive for the initialized data section

szNodeIndex:	.skip 12		@ Skip 12 for a string variable for displaying an index value	
iTemp:		.word 0			@ NULL pointer used for a temp variable used for displaying
cNewLine:	.byte 10		@ Character for the line feed to print new line

szOpenBracket:	.asciz "["		@ String variable for printing an opening square bracket
szCloseBracket:	.asciz "] "		@ String variable for printing a closing square bracket with a trailing space

.text					@ Directive for the text section
	.global displayList		@ Provides subroutine starting address to linker
	
displayList:				@ Label for the start of the display list subroutine
	push 	{r4-r8, r10, r11, lr}	@ Pushes AAPCS Register and LR

	ldr	r4, =iTemp		@ Loads iTemp address into r4
	str 	r0, [r4]		@ Stores headPtr into iTemp
	mov	r8, r1			@ Move # nodes into r8
	mov 	r5, #0			@ Starts counter (index) initialized to 0

displayLoop:				@ Loop for printing and traversing through the entire list
	cmp 	r8, r5			@ If # of nodes == current index
	beq 	endListDisplay		@ Branch to end (end of list) (if equal)

	ldr 	r0, =szOpenBracket	@ Load open bracket
	bl 	putstring		@ Print [

	mov 	r0, r5			@ Load index into r0
	ldr 	r1, =szNodeIndex	@ Loads szNodeIndex address into r1
	bl 	intasc32		@ Convert index to ascii and store in szNodeIndex

	ldr 	r0, =szNodeIndex	@ Load szNodeIndex address
	bl 	putstring		@ Prints current index
	
	ldr 	r0, =szCloseBracket	@ Loads close bracket
	bl 	putstring		@ Prints ]
	
	ldr 	r6, [r4]		@ Loads pointer to current node into r6
	ldr 	r0, [r6]		@ Dereferences to get address of string in node
	bl 	putstring		@ Prints string

	ldr 	r0, =cNewLine		@ Loads new line
	bl 	putch			@ Prints new line

	ldr 	r7, [r6, #4]		@ Load to point to head of next node
	str 	r7, [r4]		@ Dereference to get head of next node
	
	cmp 	r7, #0			@ If ptr == NULL
	beq 	endListDisplay		@ End of List, branch to end (if equal)
	
	add 	r5, #1			@ Increment index by 1
	b 	displayLoop		@ Continue looping until entire list is printed
	
endListDisplay:				@ Label for the end of the display list subroutine
	pop 	{r4-r8, r10, r11, lr}	@ Pop APPCS and LR registers (restores)
	bx 	lr			@ Return to caller

