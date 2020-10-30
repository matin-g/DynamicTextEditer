/******************************************************************************************
 * Name   : Milan Bui
 * Program: String2.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.03.30
 * Purpose:
 *	Contains half of the string functions for RASM 3: String_length, String_indexOf_1, 
 *	String_indexOf_2, String_indexOf_3, String_lastIndexOf_1, String_lastIndexOf_2,
 *	String_lastIndexOf_3, String_replace, String_toLowerCase, String_toUpperCase,
 *	String_concat. (AAPCS compliant)
 ******************************************************************************************/

	.global String_length
	.global String_indexOf_1
	.global String_indexOf_2
	.global String_indexOf_3
	.global String_lastIndexOf_1
	.global String_lastIndexOf_2
	.global String_lastIndexOf_3
	.global String_replace
	.global String_toLowerCase
	.global String_toUpperCase
	.global String_concat

/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_length.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.03.25
 *
 * CONTRACT:
 * Subroutine String_Length accepts the address of a string and counts the characters in
 * the string, excluding the NULL character and returns that value as an int (word) in r0.
 * Will read a string of characters terminated by a NULL.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Number of characters in the string (does not include NULL)
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_length:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r4, #0		@ Sets counter

loop_1:
	ldrb	r5, [r0], #1	@ Loads r5 with char from string and increments address
	
	cmp	r5, #0		@ If r5 == NULL
	beq	end_1		@ Branch to end

	add	r4, r4, #1	@ Else, increment counter

	b	loop_1		@ Loops

end_1:
	mov	r0, r4		@ Loads result into r0
	
	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_indexOf_1.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.03.30
 *
 * CONTRACT:
 * Subroutine String_indexOf_1 takes 2 arguments: string (R0) and char (R1). It finds the
 * first occurrence of char in string and returns its index in R0. If index returned is
 * -1, char was not found.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	R1: Character searching for
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Index of first occurrence of specified character in string
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_indexOf_1:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, #0		@ Sets counter
	mov	r6, #-1		@ Sets found index
loop_2:
	ldrb	r4, [r0], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_2		@ Branch to end
	
	cmp	r4, r1		@ || r4 == r1 (char)
	moveq	r6, r5		@ Move current index into found index
	beq	end_2		@ Branch to end

	add	r5, r5, #1	@ Increments counter (index)
	b	loop_2		@ Loops (moves to next index)

end_2:	
	mov	r0, r6		@ Sets r0 to index

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pops r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_indexOf_2.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.03.30
 *
 * CONTRACT:
 * Subroutine String_indexOf_2 takes 3 arguments: string (R0), char (R1), index (R2). It 
 * finds the first occurrence of char in string starting from index in R2 and returns its
 * index in R0. If index returned is -1, char was not found.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	R1: Character searching for
 *	R2: Index to start searching from
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Index of first occurrence of specified character in string from given index
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_indexOf_2:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	ldr	r4, [r0], r2	@ Loads r0 into r4 then increments to index r2
	mov	r5, r2		@ Sets counter (index)
	mov	r6, #-1		@ Sets found index
loop_3:
	ldrb	r4, [r0], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_3		@ Branch to end
	
	cmp	r4, r1		@ || r4 == r1 (char)
	moveq	r6, r5		@ Move current index into found index
	beq	end_3		@ Branch to end

	add	r5, r5, #1	@ Increments counter (index)
	b	loop_3		@ Loops (moves to next index)

end_3:	
	mov	r0, r6		@ Sets r0 to index

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pushes r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_indexOf_3.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.03.30
 *
 * CONTRACT:
 * Subroutine String_indexOf_2 takes 2 arguments: string1 (R0), str (R1). It finds the
 * first occurrence of str in string and returns its index in R0. If index returned is
 * -1, char was not found.
 *
 *	R0: Points to first byte of string1 to point (address of string)
 *	R1: Points to first byte of string searching for (str address)
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Index of first occurrence of specified string in string from given index
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_indexOf_3:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, #0		@ Sets counter (index)

loop_4:
	ldrb	r4, [r0], #1	@ Loads r4 with char from string1 and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	moveq   r7, #-1		@ If empty string, return -1 for not found
	beq	end_4		@ Branch to end of program
	
	mov	r6, r1		@ Loads r1 (str) into r6
	ldrb	r7, [r6], #1	@ Loads first char of str and increments address
	cmp	r4, r7		@ If r4 == r7 (char in str)
	moveq	r8, r5		@ Mov current index into r8 (found index)
	add	r5, r5, #1	@ Increments counter (index)
	beq	loop_match_1	@ Branch to loop to check if following chars match

	b	loop_4		@ Loops (moves to next index)

loop_match_1:
	ldrb	r4, [r0], #1	@ Loads next char from string and increments address
	ldrb	r7, [r6], #1	@ Loads next char from str and increments address
	
	cmp 	r4, #0		@ If string1[index] == NULL
	cmpne	r7, #0		@ || str[index] == NULL
	beq	end_4		@ Branch to end of program
	
	cmp	r4, r7		@ If string1[index] != str[index]
	add	r5, r5, #1	@ Increments index
	bne	loop_4		@ Branch back to loop

	b	loop_match_1	@ Loops

end_4:	
	cmp	r7, #0		@ If str == NULL (str found)
	moveq	r0, r8		@ Sets r0 to index of str found
	movne	r0, #-1		@ Else, sets index to -1 to signal not found

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pushes r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_lastIndexOf_1.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.02
 *
 * CONTRACT:
 * Subroutine String_lastIndexOf_1 takes 2 arguments: string (R0) and char (R1). It finds 
 * the last occurrence of char in string and returns its index in R0. If index returned is
 * -1, char was not found.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	R1: Character searching for
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Index of last occurrence of specified character in string
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_lastIndexOf_1:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, #0		@ Sets counter
	mov	r6, #-1		@ Sets found index
loop_5:
	ldrb	r4, [r0], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_5		@ Branch to end if reach end of string

	cmp	r4, r1		@ If r4 == char
	moveq	r6, r5		@ Loads current index into r6

	add	r5, r5, #1	@ Increments counter (current index)
	b	loop_5		@ Loops (moves to next index)

end_5:	
	mov	r0, r6		@ Sets r0 to last index of match

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pops r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_lastIndexOf_2.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.02
 *
 * CONTRACT:
 * Subroutine String_lastIndexOf_2 takes 3 arguments: string (R0), char (R1), index (R2).  
 * It finds the last occurrence of char in string starting from index in R2 and returns its
 * index in R0. If index returned is -1, char was not found.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	R1: Character searching for
 *	R2: Index to start searching from
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Index of last occurrence of specified character in string from given index
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_lastIndexOf_2:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, #0		@ Counter current index
	mov	r6, #-1		@ Sets found index
loop_6:
	ldrb	r4, [r0], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	cmpne	r5, r2		@ If current index equals the fromIndex
	beq	end_6		@ Branch to end
	
	cmp	r4, r1		@ || r4 == r1 (char)
	moveq	r6, r5		@ Move current index into found index

	add	r5, r5, #1	@ Increments counter (index)
	b	loop_6		@ Loops (moves to next index)

end_6:	
	mov	r0, r6		@ Sets r0 to index

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pushes r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_lastIndexOf_3.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.02
 *
 * CONTRACT:
 * Subroutine String_lastIndexOf_2 takes 2 arguments: string (R0), str (R1). It finds the
 * last occurrence of str in string and returns its index in R0. If index returned is
 * -1, char was not found.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	R1: Points to first byte of string searching for (str)
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: Index of last occurrence of specified string in string from given index
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_lastIndexOf_3:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, #0		@ Sets counter (index)
	mov	r8, #-1		@ Sets found index to -1

loop_7:
	ldrb	r4, [r0], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_7		@ Branch to end of 
	
	mov	r6, r1		@ Loads r1 (str) into r6
	ldrb	r7, [r6], #1	@ Loads first char of str and increments address
	cmp	r4, r7		@ If r4 == r7 (char in str)
	moveq	r8, r5		@ Load current index into found index
	add	r5, r5, #1	@ Increments counter (index)
	beq	loop_match_2	@ Branch to loop to check if following chars match

	b	loop_7		@ Loops (moves to next index)

loop_match_2:
	ldrb	r4, [r0], #1	@ Loads next char from string and increments address
	ldrb	r7, [r6], #1	@ Loads next char from str and increments address
	

	cmp	r7, #0		@ If str[index] == NULL
	beq	loop_7		@ Branch back to loop	

	cmp 	r4, #0		@ Else if string[index] == NULL && 
	moveq	r8, #-1		@ Load -1 into found index 
	beq	end_7		@ Branch to end of program
	
	cmp	r4, r7		@ If string[index] != str[index]
	add	r5, r5, #1	@ Increments index
	movne	r8, #-1
	bne	loop_7		@ Branch back to loop

	b	loop_match_2	@ Loops

end_7:	
	mov	r0, r8		@ Moves found index into R0 to return

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pushes r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_replace.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.02
 *
 * CONTRACT:
 * Subroutine String_replace takes 3 arguments: string (R0), oldChar (R1), newChar (R2).
 * Replaces all the oldChar characters in the string with the given newChar. Returns this
 * new string with the replacements.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	R1: Character to replace
 *	R2: New character to replace with
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: String with the given old characters replaced with the given new ones
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_replace:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, r0		@ Loads starting address of string into r5

loop_8:
	mov	r6, r5		@ Loads initial address to r6
	ldrb	r4, [r5], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_8		@ Branch to end if reach end of string

	cmp	r4, r1		@ If r4 == char
	streqb	r2, [r6]	@ Replaces character

	b	loop_8		@ Loops (moves to next index)

end_8:	

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pops r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_toLowerCase.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.02
 *
 * CONTRACT:
 * Subroutine String_toLowerCase takes 1 argument: string (R0). Replaces all the uppercase
 * characters in the string with the lowercase. Returns this new string.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: String changed to all lowercase characters
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_toLowerCase:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, r0		@ Loads starting address of string into r5

loop_9:
	mov	r6, r5		@ Loads initial address to r6
	ldrb	r4, [r5], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_9		@ Branch to end if reach end of string

	cmp	r4, #0x41	@ If r4 > 0x41 ('A')
	addge	r7, r4, #32	@ Change to lowercase
	movlt	r7, r4		@ Else, move current char to r7

	cmp	r4, #0x5A	@ If r4 < 0x5A ('Z')	
	strleb	r7, [r6]	@ Replaces character

	b	loop_9		@ Loops (moves to next index)

end_9:	

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pops r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_toUpperCase.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.02
 *
 * CONTRACT:
 * Subroutine String_toUpperCase takes 1 argument: string (R0). Replaces all the lowercase
 * characters in the string with the uppercase. Returns this new string.
 *
 *	R0: Points to first byte of string to point (address of string)
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: String changed to all uppercase characters
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

String_toUpperCase:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r5, r0		@ Loads starting address of string into r5

loop_10:
	mov	r6, r5		@ Loads initial address to r6
	ldrb	r4, [r5], #1	@ Loads r4 with char from string and increments address
	
	cmp	r4, #0		@ If r4 == NULL
	beq	end_10		@ Branch to end if reach end of string

	cmp	r4, #0x61	@ If r4 > 0x61 ('a')
	subge	r7, r4, #32	@ Change to uppercase
	movlt	r7, r4		@ Else, move current char to r7

	cmp	r4, #0x7A	@ If r4 < 0x7A ('z')	
	strleb	r7, [r6]	@ Replaces character

	b	loop_10		@ Loops (moves to next index)

end_10:	

	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pops r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program


/******************************************************************************************
 * Name   : Milan Bui
 * Program: String_concat.s
 * Lab    : RASM 3
 * Class  : CS3B MW 3:30p-5:50p
 * Date   : 2020.04.03
 *
 * CONTRACT:
 * Subroutine String_concat takes 2 arguments: string1 (R0) and str (R1). Concatenates str 
 * at the end of string. Returns this new string.
 *
 *	R0: Points to first byte of string1 to point (address of string)
 *	R1: Points to first byte of str to concatenate
 *	LR: Contains return address
 *
 * Returned register contents:
 *	R0: String1+str (concatenated string)
 *
 * All registers are preserved as per AAPCS
 *****************************************************************************************/

	.extern malloc		@ Using extern directive to provide assembler with malloc c function
	.extern free		@ Using extern directive to provide assembler with free c function

String_concat:
	push	{r4}		@ Pushes r4 onto stack (preserves register)
	push	{r5}		@ Pushes r5 onto stack (preserves register)
	push	{r6}		@ Pushes r6 onto stack (preserves register)
	push	{r7}		@ Pushes r7 onto stack (preserves register)
	push	{r8}		@ Pushes r8 onto stack (preserves register)
	push	{r9}		@ Pushes r9 onto stack (preserves register)
	push 	{r10}		@ Pushes r10 onto stack (preserves register)
	push	{r11}		@ Pushes r11 onto stack (preserves register)
	push	{lr}		@ Pushes link register onto stack (preserves)

	mov	r4, r0		@ Moves R0 (start address of string1) to R4
	mov	r5, r1		@ Moves R1 (start address of str) to R5
	
	bl	String_length	@ Finds length of R0 (string1)
	mov	r6, r0		@ Moves length of string1 into R6
	
	mov	r0, r1		@ Moves start address of str into r0
	bl	String_length	@ Finds length of str
	
	add	r0, r0, r6	@ R0 = string1.length() + str.length()
	add 	r0, r0, #1	@ adds 1 (space for NULL)
	bl	malloc		@ Dynamically allocates memory (new memory address in R0)
	mov	r7, r0		@ Moves new address into R7
	mov	r8, r4		@ Moves string1 address into r8

loop_string:
	ldrb	r6, [r4], #1	@ Loads char of string1 into R6, increments address
	
	cmp	r6, #0		@ If string1[index] != NULL
	strneb	r6, [r0], #1	@ Store first char of string1 into R0 (string to return)
				@ conditional keeps from placing NULL in middle of string
	bne	loop_string	@ and loop

loop_str:
	ldrb	r4, [r5], #1	@ Loads char of str into R4, increments address
	strb	r4, [r0], #1	@ Stores char of str into R0 (string to return)

	cmp	r4, #0		@ If str[index] != NULL
	bne	loop_str	@ Loop

end_11:	
	mov	r0, r8		@ Moves R1 (start address of string1) to R5
	bl	free		@ Deallocates old memory location
	mov	r0, r7		@ Move start address of new memory back into R0 to return
	
	pop 	{lr}		@ Contains return address (pops and restores value)
	pop	{r11}		@ Pops r11 from stack (Restores values)
	pop	{r10}		@ Pops r10 from stack (Restores values)
	pop	{r9}		@ Pops r9 onto stack (preserves register)
	pop	{r8}		@ Pops r8 from stack (Restores values)
	pop	{r7}		@ Pops r7 from stack (Restores values)
	pop	{r6}		@ Pops r6 from stack (Restores values)
	pop	{r5}		@ Pops r5 from stack (Restores values)
	pop	{r4}		@ Pops r4 from stack (Restores values)
	
	bx	lr		@ Return to the calling program
