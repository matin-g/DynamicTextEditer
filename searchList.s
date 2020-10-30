/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : searchList.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts three arguments: headPtr (R0), # Nodes (R1), & string (R2).
 * It traverses through the linked lists full of strings, displaying any string containing
 * the search key (sub string).
 *	R0: Pointer to head of linked list
 *	R1: Number of nodes in the linked list
 *	R2: Substring to search for
 *	LR: Return address
 * Returns:
 *	R0: If match was found (returns -1 if not found)
 * AAPCS Compliant
 ****************************************************************************************/

.data					@ Directive for the initialized data section

szNodeIndexSearch:	 .skip 12	@ Skip 12 for a string variable for displaying an index value	
iTempSearch:	 	 .word 0	@ NULL pointer used for a temp variable used for searching
iCopyTemp:	 	 .word 0	@ NULL pointer used for a temp variable used for copying a string
cNewLineSearch:	 	 .byte 10	@ Character for the line feed to print new line

szOpenBracket2:		 .asciz "["	@ String variable for printing an opening square bracket
szCloseBracket2:	 .asciz "] "	@ String variable for printing a closing square bracket with a trailing space

.text					@ Directive for the text section
	.global searchList		@ Provides subroutine starting address to linker
	.extern free			@ Using extern directive to provide assembler with free c function

searchList:				@ Label for the start of the search subroutine
	push 	{r4-r8, r10, r11, lr}	@ Pushes AAPCS registers and LR
	ldr	r4, =iTempSearch	@ Loads iTempSearch address into r4
	str 	r0, [r4]		@ Stores headPtr into iTempSearch
	mov	r8, r2			@ Loads searchKey into r8
	mov 	r5, #0			@ Starts counter (index) initialized to 0
	mov	r9, r1			@ Loads # of nodes in r9

loop_search:				@ Label for the loop that searches for the corresponding string
	cmp 	r9, r5			@ If index == # of Nodes
	beq 	end_search		@ Branch to end of program (if equal)

	ldr	r6, [r4]		@ Loads headPtr into r6
	ldr	r0, [r6]		@ Loads string address in node into r0
	bl	String_copy		@ Makes a copy of the string
	ldr	r1, =iCopyTemp		@ Loads iCopyTemp into r1
	str	r0, [r1]		@ Stores the copy into iCopyTemp

	bl	String_toLowerCase	@ Converts the string into lowercase
	
	mov	r0, r8			@ Loads searchKey into r0
	bl	String_toLowerCase	@ Converts the search key into lowercase
	mov	r1, r0			@ Loads converted search key into r1
	
	ldr	r0, =iCopyTemp		@ Loads iCopyTemp address
	ldr	r0, [r0]		@ Dereferences to get address of string
	bl	String_indexOf_3	@ Searches for the key in the string
	
	cmp	r0, #-1			@ If foundIndex != -1
	bne	match			@ Branch to match (match found) (if not equal)

end_loop:				@ Label for the end of the loop that searches for the corresponding string
	ldr	r0, =iCopyTemp		@ Loads iCopyTemp address
	ldr	r0, [r0]		@ Dereferences to get address of string
	bl	free			@ Deallocates the memory made from copy
	
	ldr 	r7, [r6, #4]		@ Gets pointer to head of next node
	str 	r7, [r4]		@ Gets head of node
	
	cmp 	r7, #0			@ If head == NULL
	beq 	end_search		@ Branch to end (end of list) (if equal)
	add 	r5, #1			@ Increments index by 1

	b 	loop_search		@ Continue searching through list

match:					@ Label for printing the matched strings
	ldr	r0, =szOpenBracket2	@ Loads open bracket
	bl 	putstring		@ Prints [

	mov 	r0, r5			@ Loads current index into r0		
	ldr 	r1, =szNodeIndexSearch	@ Loads szNodeIndexSearch address into r1
	bl 	intasc32		@ Converts index to ascii and stores it in szNodeIndexSearch

	ldr 	r0, =szNodeIndexSearch	@ Loads szNodeIndexSearch address into r0
	bl 	putstring		@ Prints current index
	
	ldr 	r0, =szCloseBracket2	@ Loads close bracket
	bl 	putstring		@ Prints ]

	ldr 	r0, [r6]		@ Loads address of string of current node
	bl 	putstring		@ Prints string
	
	ldr 	r0, =cNewLineSearch	@ Loads new line
	bl 	putch			@ Prints new line
	
	mov	r10, #-1		@ Flag that match found (used to compare later)
	
	b 	end_loop		@ Else, Jump up to ending half of search loop

end_search:				@ Label for the end of the search subroutine
	cmp	r10, #-1		@ If r10 != -1
	movne	r0, #-1			@ Match not found, return -1 in r0 (if not equal)

	pop 	{r4-r8, r10, r11, lr}	@ Pops AAPCS registers and LR (restores)
	bx	lr			@ Return to caller
