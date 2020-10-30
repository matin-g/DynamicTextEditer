/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : getline.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts two arguments: file handle (R0) & buffer address (R1). It
 * reads in from the file 1 byte at a time, loading into the buffer. When it reaches
 * the end of a string (line feed) or a carriage return, it adds a null (0x00) to the
 * end of the string and returns the beginning address of buffer which holds the string.
 *	R0: File handle
 *	R1: Buffer address
 *	LR: Return address
 * Returns:
 *	R0: String (1 line) from file
 * AAPCS Compliant
 ****************************************************************************************/

	.global getline			@ Provides subroutine starting address to linker

getline:				@ Label for the start of the getline subroutine
	push	{r2, r4-r11, lr}	@ Pushes AAPCS registers and LR and r2

	mov	r4, r0			@ Loads fileHandle into r4 b/c r0 will be overwritten when reading file
	mov	r5, r1			@ Loads buffer address so not lost to traverse	
	mov	r8, r1			@ Loads buffer address into r8 as well
	
loop:					@ Label for the loop that reads the string
	mov	r1, r5			@ Load address into r1
	mov	r2, #1			@ Bytes to read from file
	mov	r7, #3			@ Read from input file into buffer. Returns # bytes read (0 if end of file). Advances file position by this number
	svc	0			@ Supervisor call set to 0

	cmp	r0, #0			@ If end of file
	moveq	r1, #-1			@ -1 into r1 (end of file) (if equal)
	moveq	r6, #0x00		@ Load NULL (if equal)
	streq	r6, [r5]		@ Store NULL (if equal)
	beq	end			@ Branch to end of subroutine (if equal)

	ldrb	r6, [r5]		@ Loads byte that was read into r6
	cmp	r6, #0xa		@ If byte == Line Feed 
	moveq	r6, #0x00		@ Load NULL (if equal)
	streq	r6, [r5]		@ Store NULL (if equal)
	beq	end			@ Branch to end of subroutine (if equal)

	add	r5, #1			@ Else, increment address by 1
	mov	r0, r4			@ Else, load file handle into r0
	b	loop			@ Else, keep reading

end:					@ Label for the end of the getline subroutine
	mov	r0, r8			@ Loads buffer beginning address to r0 to return
	
	pop	{r2, r4-r11, lr}	@ Pops AAPCS registers and LR and r2 (restores)
	bx	lr			@ Return to caller
	