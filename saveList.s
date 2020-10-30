/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : saveList.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts three arguments: headPtr (R0), # Nodes (R1), & FileHandle (R2).
 * It traverses through the linked lists full of strings, writing those strings into the
 * file whose file handle was passed.
 *	R0: Pointer to head of linked list
 *	R1: Number of nodes in the linked list
 *	R2: File Handle
 *	LR: Return address
 * Returns:
 *	None
 * AAPCS Compliant
 ****************************************************************************************/

.data					@ Directive for the initialized data section

iTempSave:	.word 0			@ NULL pointer used for a temp variable used for saving
szTempSave:	.skip 512		@ 512 bytes for a string variable used for the integer temp

.text					@ Directive for the text section
	.global save_list		@ Provides subroutine starting address to linker

save_list:				@ Label for the start of the save subroutine
	push	{r4-r11, lr}		@ Pushes AAPCS and LR registers
	mov	r11, r1			@ Loads R1 (# Nodes) into R11 b/c R1 will be overwritten
	mov	r8, r2			@ Loads R2 (file handle) into r8 b/c r2 will be overwritten

	ldr	r4, =iTempSave		@ Loads iTempSave address into r4
	str 	r0, [r4]		@ Store head pointer into iTempSave

	mov 	r5, #0			@ Start counter initialized to 0

loop_save:				@ Label for the save loop
	cmp 	r11, r5			@ If counter == number of nodes
	beq 	end_save		@ Go to end (if equal)

	ldr 	r6, [r4]		@ Else, load address of current node to r6
	ldr 	r10, [r6]		@ Load address of string in node to r6
	mov	r0, r10			@ Loads string address to r0
	bl	String_length		@ Gets length of string
	cmp	r0, #0			@ If NULL (Empty line)
	beq	carriage_return		@ Branch to carriage_return (if equal)

	mov	r2, r0			@ r2 = length > # bytes to write 
	mov	r0, r8			@ Move file handle into r0
	mov	r1, r10			@ Loads string address into r1
	mov	r7, #4			@ Writes into output file
	svc	0			@ Supervisor call set to 0

	mov	r10, r5			@ Moves counter into r10
	add	r10, #1			@ Adds 1 to r10
	cmp	r10, r11		@ If this == last node
	beq	end_save		@ Branch to end (if equal)

	ldr	r10, =szTempSave	@ Loads temp
	mov	r9, #0xa		@ Loads line feed into r9
	str	r9, [r10]		@ Stores line feed

	mov	r2, #1			@ # bytes to write 
	mov	r0, r8			@ Move file handle into r0
	mov	r1, r10			@ Loads string address into r1
	mov	r7, #4			@ Writes into output file
	svc	0			@ Supervisor call set to 0

	b	next_node		@ Branch to next node

carriage_return:			@ Condition for handling carriage returns
	mov	r10, r5			@ Moves counter into r10
	add	r10, #1			@ Add 1 to r10
	cmp	r10, r11		@ If this == last node
	beq	end_save		@ Branch to end (if equal)

	ldr	r10, =szTempSave	@ Loads temp
	mov	r9, #0xa		@ Loads line feed into r9
	str	r9, [r10]		@ Stores line feed

	mov	r2, #1			@ # bytes to write 
	mov	r0, r8			@ Move file handle into r0
	mov	r1, r10			@ Loads string address into r1
	mov	r7, #4			@ Writes into output file
	svc	0			@ Supervisor call set to 0

next_node:				@ Label for condition that traverses to the next node
	ldr 	r7, [r6, #4]		@ Loads next pointer
	str 	r7, [r4]		@ Stores next pointer to become "head"
	
	cmp 	r7, #0			@ If next is NULL
	beq 	end_save		@ Go to end of subroutine (end of list) (if equal)
	
	add 	r5, #1			@ Else, increment counter by 1
	b 	loop_save		@ Continue traversing

end_save:				@ Label for the end of the save subroutine
	pop	{r4-r11, lr}		@ Pop AAPCS and LR registers
	bx	lr			@ Return to caller
