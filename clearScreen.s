/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : clearScreen.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract: 
 * Clears the screen by printing new lines, (new line passed in r0) 60 times
 *	R0: contains new line character
 * Returns:
 * 	None. Displays to console.
 *****************************************************************************************/

	.global clear_screen		@ Provides subroutine starting address to linker

clear_screen:				@ Label for the start of the clear screen subroutine
	push	{r4-r11,lr}		@ Pushes AAPCS registers and LR
	mov	r4, #0			@ Initialize loop counter to 0

loopClearScreen:			@ Loop for printing the passed in new line character 60 times
	cmp	r4, #60			@ Compares the counter to 60 to check to see when printing is done
	beq	endClearScreen		@ When the counter equals 60, branch to the end of the subroutine to exit subroutine

	bl	putch			@ Prints new line character to the terminal
	add	r4, #1			@ Increment the loop counter by 1
	b	loopClearScreen		@ Branch to loopClearScreen until the character prints 60 times

endClearScreen:				@ Label for the end of the clear screen subroutine
	pop	{r4-r11,lr}		@ Pops AAPCS registers and LR (restores)
	bx	lr			@ Return to caller
