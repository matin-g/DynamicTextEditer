@**********************************************************************
@  Author : Matin Ghaffari
@ Program : String1.s
@     Lab : RASM 3
@   Class : CS 3B MW 3:30 P.M. - 5:50 P.M.
@    Date : 4/8/2020 
@
@ Purpose : String 1.s contains half of the string functions for RASM3
@	    which are AAPCS compliant. These functions include
@	    String_Length, String_equals, String_equals_IgnoreCase,
@	    String_copy, String_substring_1, String_substring_2,
@	    String_CharAt, String_startsWith_1, String_startsWith_2,
@	    and String_endsWith.
@**********************************************************************

@**********************************************************************
@ Subroutine String_Length: This method is an external function that
@			    points to the address of a string passed
@			    in through r0, then the method counts
@ 	                    the characters in the string, excluding the
@			    NULL character and returns that value as an
@			    int (word) in the r0 register. Will read a
@			    string of characters terminated by a null.
@
@    R0: Points to first byte of string to count
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Number of characters in the string (does not include null).
@
@ All registers are preserved as per AAPCS
@**********************************************************************

.global String_Length		@ Provides function starting address to linker

String_Length:			@ Subroutine, String_Length external function -> String_length(string1:String):int   
	push {r4-r11}		@ Preserve working register contents. Save contents of AAPCS registers (pushing data onto stack to store, LIFO)

	mov r4, #0		@ Initializing the count for the string length to 0

countLoop:			@ Label for the loop that counts characters until compare detects an end of a string (NULL)
	ldrb r5, [r0], #1	@ Load into r5 each byte (character) and updates address to point to the next character of string

	cmp r5, #0		@ Comparing the contents of the current byte to 0 to check for NULL (end of string)
	moveq r0, r4		@ If element equals null, copy r4, the count for the string length, to r0 to be returned
	beq endStrLen		@ Branch to end of loop condition if the character is a NULL (end of string)
	
	add r4, #1		@ Else increment the count for the string length
	b countLoop		@ Branch to start of countLoop to loop and to read the next character 
	
endStrLen:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11}		@ Restore saved AAPCS register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@********************************************************************************************************
@ Subroutine String_equals: This method is an external function that points to the addresses of two strings
@			    passed in with r0 and r1. Then this method makes an exact comparison of individual
@			    characters in two strings. If any character in the string in a position is
@			    different than the character in the same position in the other string, the
@			    method returns “false” (0  in the r0 register). If the length of the two
@			    strings is different, the method also returns “false”. (e.g. ‘e’ is NOT the
@			    same as 'E'). Otherwise “true” (1) is returned. The value is returned in 
@			    the r0 register.
@
@    R0: Points to the address of the first string
@    R1: Points to the address of the second string
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Contains a boolean value (1 or 0) for the equality of the strings
@
@ All registers are preserved as per AAPCS
@********************************************************************************************************

.global String_equals		@ Provides function starting address to linker
 
String_equals:			@ Subroutine, external function -> String_equals(string1:String,string2:String):boolean (byte)
	push {r4-r11, lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)
	
	mov r4, r0		@ Copy r0, the string address, to r4

	bl String_Length	@ Branch and link to String_Length subroutine to get the first string length
	mov r5, r0		@ Copy r0, the first string length, to r5
	
	mov r0, r1		@ Copy r1, the second string, to r0
	bl String_Length	@ Branch and link to String_Length subroutine to get the second string length
	mov r6, r0		@ Copy r0, the second string length, to r6
	
	cmp r5, r6		@ Compare the lengths of the two strings passed in
	movne r0, #0		@ If the two lengths are not equal then set return value to 0
	bne endStrEquals	@ If the two lengths are not equal then branch to the end of the subroutine
	
lenCmpLoop:			@ Label for lenCmpLoop that checks for equality amongst the elements of the two strings
	ldrb r7, [r4], #1	@ Load into r7 each byte (character) and updates address to point to the next character of string 1 (r4)
	ldrb r8, [r1], #1	@ Load into r8 each byte (character) and updates address to point to the next character of string 2 (r1)

	cmp r7, r8		@ Compare characters at the current index of the two strings
	movne r0, #0		@ If elements are not equal, move 0 to r0 for false return value
	bne endStrEquals	@ If elements are not equal, then branch to the end of the subroutine to return 0

	cmp r7, #0		@ Check for null in r7 since both strings have the same length, to determine the end of strings and equality comparison
	moveq r0, #1		@ If element in r7 equals NULL (end is reached), move 1 to r0 for true return value
	beq endStrEquals	@ If element in r7 equals NULL (end is reached), then branch to the end of the subroutine
		
	b lenCmpLoop		@ Branch to lenCmpLoop to loop for comparing the elements to check for their equality

endStrEquals:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*************************************************************************************************************
@ Subroutine String_equals_IgnoreCase: This method is an external function that points to the addresses of
@				       two strings passed in with r0 and r1. Then this method makes a comparison
@				       of individual characters in the two strings ignoring case. If any character
@				       in the string in a position is different than the character in the same
@				       position in the other string, the method returns “false” (0 in the r0 
@				       register). If the length of the two strings is different, the method
@				       also returns “false”. (e.g. ‘e’ is the SAME as ‘E’). The value returned
@				       is in the r0 register.
@
@    R0: Points to the address of the first string
@    R1: Points to the address of the second string
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Contains a boolean value (1 or 0) for the equality of the strings
@
@ All registers are preserved as per AAPCS
@*************************************************************************************************************

.global String_equals_IgnoreCase	@ Provides function starting address to linker

String_equalsIgnoreCase: 		@ Subroutine, external function -> String_equalsIgnoreCase(string1:String,string2:String):boolean (byte)
	push {r4-r11,lr}		@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)

	mov r4, r0			@ Copy r0, the first string address, to r4
	mov r5, r1			@ Copy r1, the second string address, to r5
	mov r10, #0			@ Initialize counter to 0, used for stepping through each element

	bl String_Length		@ Branch and link to String_Length subroutine to get the first string length
	mov r6, r0			@ Copy r0, the first string length, to r6

	mov r0, r1			@ Copy r1, the second string, to r0
	bl String_Length		@ Branch and link to String_Length subroutine to get the second string length
	mov r7, r0			@ Copy r0, the second string length, to r7

	cmp r6, r7			@ Compare the lengths of the two strings passed in
	movne r0, #0			@ If the two lengths are not equal then set return value to 0
	bne endStrEquIgnore		@ If the two lengths are not equal then branch to the end of the subroutine to return 0

checkCase:				@ Top of loop that checks ASCII ranges of elements to ensure they are in the same range before checking they equal
	cmp r6, #0			@ Compare r6 to 0, since r6 is the length decremented by 1 each iteration until it hits 0 which is when it is done
	moveq r0, #1			@ Move 1 to r0 for true return value if r6 == 0 (length(count) == 0), which is the end of the loop
	beq endStrEquIgnore		@ If r6 == 0 (length(count) == 0), branch to the end of the subroutine
	
	ldrb r8, [r4, r10]		@ Load byte for each element at specified index of r4 (string 1) to r8
	ldrb r9, [r5, r10]		@ Load byte for each element at specified index of r5 (string 2) to r9

	cmp r8, #65			@ Compare r8 to 65 to check if the element of string 1 is not an alphabetical character
	blt checkEqual			@ Branch if r8 < 65 to check if element in r9 and r8 are equal if they r8 is not an alphabetical characters

	cmp r8, #97			@ Compare r8 to 97 to check if the element of string 1 is a lower case
	bge lowerCase			@ Branch if r8 >= 97 to lowerCase to make sure r9 is also in the lower case alphabetical character ASCII range

	cmp r8, #65			@ Compare r8 to 65 to check if the element of string 1 is a upper case
	bge upperCase			@ Branch if r8 >= 65 to upperCase to make sure r9 is also in the upper case alphabetical character ASCII range
 
lowerCase:				@ Condition to ensure string 2 element is also lower case if string 1 element is lower case
	cmp r9, #97			@ Compare r9 to 97 to check if it is already lower case
	addlt r9, #32			@ If r9 is less than 97, it adds 32 to r9 to convert it from upper to lower case

	b checkEqual			@ Now both elements are ensured to be lower case ASCII values, branch to checkEqual to check if elements are equal

upperCase:				@ Condition to ensure string 2 element is also upper case if string 1 element is upper case
	cmp r9, #97			@ Compare r9 to 97 to check if it is already upper case
	subgt r9, #32			@ If r9 is greater than 97, it subtracts 32 from r9 to convert it from lower to upper case
	
	b checkEqual			@ Now both elements are ensured to be upper case ASCII values, branch to checkEqual to check if elements are equal
	 
checkEqual:				@ Condition for checking if elements are equal after ensuring proper ASCII value ranges
	cmp r8, r9			@ Compare r8 and r9, the two elements, to check if they are equal to each other
	movne r0, #0			@ If r8 != r9, then move 0 to r0 for a false return value
	bne endStrEquIgnore		@ If r8 != r9, branch to endStrEquIgnore to finish the subroutine and return 0

	sub r6, #1			@ Subtract 1 from the string size (r6 = r6 - 1) which is used as a counter to determine end of the loop
	add r10, #1			@ Increment 1 to the counter used to set index to the next character in the 2 strings

	b checkCase			@ Branch to top of the loop (checkCase)

endStrEquIgnore:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11, lr}		@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr				@ Return to the calling program (branch eXchange)	


@*************************************************************************************************************
@ Subroutine String_copy: This method is an external function that points to the address of a string passed in 
@			  through r0, after the method accepts a string to copy, it allocates dynamically enough
@			  storage to hold a copy of the new characters, and copies the characters and returns
@			  the address of that newly created string in r0.
@
@    R0: Points to the address of the original string
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Points to the address of the newly created string
@
@ All registers are preserved as per AAPCS
@*************************************************************************************************************

.global String_copy		@ Provides function starting address to linker
.extern malloc			@ Using extern directive to provide assembler with malloc c function

String_copy:			@ Subroutine, external function -> String_copy(string1:String):String   
	push {r4-r11, lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)

	mov r4, r0		@ Copy r0, the original string address, to r4

	bl String_Length	@ Branch and link to String_Length subroutine to get the original string length
	cmp r0, #0		@ Compare r0 to 0 to check for a empty string
	moveq r0, #0		@ If r0 == 0 (original string is empty) move 0 to r0

	mov r5, r0		@ Move string length to r5 to use as a loop counter

	add r0, #1		@ Add 1 to string length in order to allocate enough space accounting for null
	bl malloc		@ Branch and link to malloc external function to allocate memory for the new string
	mov r6, r0		@ Copy r0, address of the new string (substring), to r6
copyLoop:			@ Condition for the loop that copies the elements to the new string
	cmp r5, #0		@ Compare r5 to 0, since r5 is the length decremented by 1 each iteration until it hits 0 which is when it is done
	beq endStrCopy		@ Branch to end of this subroutine if r5 == 0, since that means all elements have been copied

	ldrb r7, [r4], #1	@ Load byte for each element of r4 (original string) to r7, incrementing by 1 to step to the next element
	strb r7, [r6], #1	@ Store byte for each element of original str to the address in r6 (new string), incrementing by 1 to step to the next position

	sub r5, #1		@ Subtract 1 from the string size (r5 = r5 - 1) which is used as a loop counter to determine the end of the loop
	b copyLoop		@ Branch to copyLoop to loop for copying the elements to the new string
	
endStrCopy:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	mov r7, #0x00		@ Move null into r7
	strb r7, [r6]		@ Attach null to the end of the string

	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*****************************************************************************************************************
@ Subroutine String_substring_1: This method is an external function that accepts the address of a string passed
@				 in r0, and the beginning index passed in r1, and the end index passed in r2, then
@				 this method method creates a new string dynamically consisting of characters 
@				 from a substring of the passed string starting with begin index and ending with 
@				 end index, and returns the substring address in r0.
@
@    R0: Points to the address of the original string
@    R1: Contains the integer begin index for the substring
@    R2: Contains the integer end index for the substring
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Points to the address of the substring
@
@ All registers are preserved as per AAPCS
@*****************************************************************************************************************

.global String_substring_1	@ Provides function starting address to linker
.extern malloc			@ Using extern directive to provide assembler with malloc c function

String_substring_1:		@ Subroutine, external function -> String_substring_1(string1:String,beginIndex:int,endIndex:int):String
	push {r4-r11, lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)

	mov r4, r0		@ Copy r0, the string address, to r4

	bl String_Length	@ Branch and link to String_Length subroutine to get the string length

	cmp r2, r0		@ Compare r2, the end index, to r0, the string length
	movgt r0, #0		@ If r2 > r0 (endIndex > string length) then move 0 to r0 for the return value
	bgt endSubStr1		@ If r2 > r0 (endIndex > string length) then branch to end of String_substring_1 subroutine to return 0

	cmp r1, r0		@ Compare r1, the begin index, to r0, the string length
	movgt r0, #0		@ If r1 > r0 (beginIndex > string length) then move 0 to r0 for the return value
	bgt endSubStr1		@ If r1 > r0 (beginIndex > string length) then branch to end of String_substring_1 subroutine to return 0

	cmp r2, r1		@ Compare r2, the end index, to r1, the begin index
	movlt r0, #0		@ If r2 < r1 (endIndex < beginIndex) then move 0 to r0 for the return value
	blt endSubStr1		@ If r2 < r1 (endIndex < beginIndex) then branch to end of String_substring_1 subroutine t0 return 0

	sub r5, r2, r1		@ r5 = r2 - r1 (substring length = endIndex - beginIndex)
	add r5, #1		@ Add 1 to string length in order to allocate enough space accounting for null

	add r4, r1		@ Add begin index to string address to find start of the substring
	
	mov r0, r5		@ Move into r0, r5 which is the amount of space needed for the substring
	bl malloc		@ Branch and link to malloc external function to allocate memory for the substring
	mov r6, r0		@ Copy r0, address of the substring, to r6

subStr1Loop:			@ Condition for the String_substring_1 loop
	cmp r5, #0		@ Compare r5 to 0, since r5 is the subStr length decremented by 1 each iteration until it hits 0 which is when it is done
	beq endSubStr1		@ Branch to end of this subroutine if r5 == 0, since that means designated elements for the substring have been copied

	ldrb r7, [r4], #1	@ Load byte for each element of r4 (original string) to r7, incrementing by 1 to step to the next element
	strb r7, [r6], #1	@ Store byte for each element of original str to the address in r6 (substring), incrementing by 1 to step to the next position

	sub r5, #1		@ Subtract 1 from the substring size (r5 = r5 - 1) which is used as a loop counter to determine the end of the loop
	b subStr1Loop		@ Branch to subStr1Loop to loop for the next element
	
endSubStr1:			@ Condition for the end of the subroutine to pop stack, and to return to the calling program
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*************************************************************************************************************
@ Subroutine String_substring_2: This method is an external function that accepts the address of a string 
@				 passed in r0, and the begin index passed in r1, then this method creates
@				 a new string, dynamically, consisting of characters from a substring of the
@				 passed string starting with begin index to the end of the original string,
@				 then the address of the substring is returned in r0.
@
@    R0: Points to the address of the original string
@    R1: Contains the integer begin index for the substring
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Points to the address of the substring
@
@ All registers are preserved as per AAPCS
@*************************************************************************************************************

.global String_substring_2	@ Provides function starting address to linker
.extern malloc			@ Using extern directive to provide assembler with malloc c function

String_substring_2:		@ Subroutine, external function -> String_substring_2(string1:String,beginIndex:int):String
	push {r4-r11, lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)

	mov r4, r0		@ Copy r0, the string address, to r4

	bl String_Length	@ Branch and link to String_Length subroutine to get the first string length

	cmp r1, r0		@ Compare r1, the begin index, to r0, the string length
	movgt r0, #0		@ If r1 > r0 (beginIndex > string length) then move 0 to r0 for the return value
	bgt endSubStr2		@ If r1 > r0 (beginIndex > string length) then branch to end of String_substring_1 subroutine to return 0

	add r0, #1		@ Add 1 to string length in order to allocate enough space accounting for null

	mov r5, r0		@ Copy r0, the substring size, to r5 which will be used as a loop counter
	add r4, r1		@ Add beginning index to string address to find start of substring

	bl malloc		@ Branch and link to malloc external function to allocate memory for the substring
	mov r6, r0		@ Copy r0, address of the substring, to r6

subStr2Loop:			@ Condition for the String_substring_2 loop
	cmp r5, #0		@ Compare r5 to 0, since r5 is the subStr length decremented by 1 each iteration until it hits 0 which is when it is done
	beq endSubStr2		@ Branch to end of this subroutine if r5 == 0, since that means designated elements have been copied

	ldrb r7, [r4], #1	@ Load byte for each element of r4 (original string) to r7, incrementing by 1 to step to the next element
	strb r7, [r6], #1	@ Store byte for each element of original str to the address in r6 (substring), incrementing by 1 to step to the next position

	sub r5, #1		@ Subtract 1 from the substring size (r5 = r5 - 1) which is used as a loop counter to determine the end of the loop
	b subStr2Loop		@ Branch to subStr2Loop to loop for the next element
	
endSubStr2:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*************************************************************************************************************
@ Subroutine String_CharAt: This method is an external function that accepts a string address passed in through
@			    r0, and the indicated index passed in through r1. Then this method returns the
@			    character in the indicated index in r0. If the request is impossible to fulfill,
@			    the method returns 0 in r0.
@
@    R0: Points to the address of a string
@    R1: Contains the integer index for the character
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Contains the character in the indicated position
@
@ All registers are preserved as per AAPCS
@*************************************************************************************************************

.global String_CharAt		@ Provides function starting address to linker

String_charAt:			@ Subroutine, external function -> String_charAt(string1:String,position:int):char (byte) 
	push {r4-r11, lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)
	mov r4, r0		@ Copy address of the string to r4

	bl String_Length	@ Branch and link to String_Length subroutine to get the string length
	cmp r0, r1		@ Compare r0, the string length, to r1, the specified index
	movlt r0, #0		@ Move 0 to r0 for the return value if length is less than index (impossible to fulfill)
	blt endCharAt		@ Branch to end of the subroutine to return 0 if length is less than index (impossible to fulfill)
	
	ldrb r0, [r4, r1]	@ Load byte for the element at specified index of r4 (string 1) to r0, for the return value

endCharAt:			@ Condition for the end of String_charAt subroutine
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*****************************************************************************************************************
@ Subroutine String_startsWith_1: This method is an external function that accepts the address of a string 
@				  passed in through r0, the beginning index passed in through r1, and the prefix
@				  passed in through r2. Then this method checks whether the substring (prefix) 
@				  (starting from the specified offset index) exists within the string, If yes
@				  then it returns 1 (true) else 0 (false), returns appropriate boolean value in r0.
@
@    R0: Points to the address of a string
@    R1: Contains the integer begin index for the substring
@    R2: Points to the address of the prefix (substring)
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Contains a boolean value (1 or 0) for the result
@
@ All registers are preserved as per AAPCS
@*****************************************************************************************************************

.global String_startsWith_1	@ Provides function starting address to linker

String_startsWith_1:		@ Subroutine, external function -> String_startsWith_1(string1:String,pos:int,strPrefix:String):boolean
	push {r4-r11,lr}	@ Preserve working register contents. Save contents of AAPCS registers  & LR (pushing data onto stack to store, LIFO)

	mov r4, r0		@ Copy address of the string, r0, to r4
	mov r5, r2		@ Copy address of the prefix (substring), r2, to r5

	bl String_Length	@ Branch and link to String_Length subroutine to get the string length
	mov r6, r0		@ Copy the length of the string to r6

	cmp r1, r6		@ Compare the begin index to the string length to check for a invalid index that is too large
	movgt r0, #0            @ If r1 > r0 (beginIndex > string length), then move 0 to r0 for the return value
	bgt endStartWith1	@ If r1 > r0 (beginIndex > string length), then branch to end of String_startsWith_1 subroutine to return 0

	mov r0, r2		@ Copy address of the prefix, r2, to r0 in order to find its length
	bl String_Length	@ Branch and link to String_Length subroutine to get the prefix string length
	mov r7, r0		@ Copy the length of the prefix (substring) to r7

	cmp r7, r6		@ Compare r7 and r6, which is the length of substring to the length of the original string 
	movgt r0, #0		@ If r7 > r6, if the substring (prefix) is longer in length then, 0 is moved in r0 for the return value
	bgt endStartWith1	@ If r7 > r6, if the substring (prefix) is longer in length then, branch to end of subroutine to return 0

	add r4, r1		@ Add the begin index to the string to set that as the starting position for the loop

startWith1Loop:			@ Loop condition for iterating through both the string and substring elements to check for their equality starting at beginIndex
	cmp r7, #0		@ Compare r7, the length of the prefix (substring) being decremented by 1, to 0 to check for when loop is done
	moveq r0, #1		@ If r7 == 0, the whole length of the prefix (substring) has been matched to start from beginIndex, then move 1 to r0 for return value
	beq endStartWith1	@ If r7 == 0, the whole length of the prefix (substring) has been matched to start from beginIndex, branch to end of subroutine to return 1

	ldrb r8, [r4], #1	@ Load byte for each element of r4 (string) to r8, incrementing by 1 to step to the next element
	ldrb r9, [r5], #1	@ Load byte for each element of r5 (prefix (substring)) to r9, incrementing by 1 to step to the next element

	cmp r8, r9		@ Compare elements of string to elements of (prefix (substring)) to check if they are != for returning 0
	movne r0, #0		@ If r8 != r9, the two elements don't match, therefore move 0 to r0 for the return value
	bne endStartWith1	@ If r8 != r9, the two elements don't match, therefore branch to end of subroutine to return 0
	
	sub r7, #1		@ r7 = r7 - 1, decrement the length of substring by 1 in order to check for 0 which is when the loop is done
	b startWith1Loop	@ Branch to startWith1Loop to loop until elements don't equal or until the specified string and substring match starting at begin index
	
endStartWith1:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*****************************************************************************************************************
@ Subroutine String_startsWith_2: This method is an external function that accepts the address of a string passed
@				  in through r0, and the prefix (substring) passed in through r1. Then this method
@				  tests whether the string begins with the specified prefix (substring). If yes
@				  then it returns 1 (true) else 0 (false). The boolean result is returned in r0.
@
@    R0: Points to the address of a string
@    R1: Points to the address of the prefix (substring)
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Contains a boolean value (1 or 0) for if the string starts with the specified prefix (substring)
@
@ All registers are preserved as per AAPCS
@*****************************************************************************************************************

.global String_startsWith_2	@ Provides function starting address to linker

String_startsWith_2:		@ Subroutine, external function -> String_startsWith_2(string1:String,strPrefix:String):boolean 
	push {r4-r11, lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)

	mov r4, r0		@ Copy address of the string, r0, to r4
	mov r5, r1		@ Copy address of the prefix (substring), r1, to r5

	bl String_Length	@ Branch and link to String_Length subroutine to get the string length
	mov r6, r0		@ Copy the length of the string to r6

	mov r0, r1		@ Copy address of the prefix, r1, to r0 in order to find its length
	bl String_Length	@ Branch and link to String_Length subroutine to get the prefix string length
	mov r7, r0		@ Copy the length of the prefix (substring) to r7

	cmp r7, r6		@ Compare r7 and r6, which is the length of substring to the length of the original string
	movgt r0, #0		@ If r7 > r6, if the substring (prefix) is longer in length, then 0 is moved in r0 for the return value
	bgt endStartWith2	@ If r7 > r6, if the substring (prefix) is longer in length, then branch to end of subroutine to return 0

startWith2Loop:			@ Loop condition for iterating through both the string and substring elements to check for their equality in the start
	cmp r7, #0		@ Compare r7, the length of the prefix (substring) being decremented by 1, to 0 to check for when loop is done
	moveq r0, #1		@ If r7 == 0, the whole length of the prefix (substring) has been matched to start, therefore move 1 to r0 for return value
	beq endStartWith2	@ If r7 == 0, the whole length of the prefix (substring) has been matched to start, branch to end of subroutine to return 1

	ldrb r8, [r4], #1	@ Load byte for each element of r4 (string) to r8, incrementing by 1 to step to the next element
	ldrb r9, [r5], #1	@ Load byte for each element of r5 (prefix (substring)) to r9, incrementing by 1 to step to the next element

	cmp r8, r9		@ Compare elements of string to elements of (prefix (substring)) to check if they are != for returning 0
	movne r0, #0		@ If r8 != r9, the two elements don't match, therefore move 0 to r0 for the return value
	bne endStartWith2	@ If r8 != r9, the two elements don't match, therefore branch to end of subroutine to return 0
	
	sub r7, #1		@ r7 = r7 - 1, decrement the length of substring by 1 in order to check for 0 which is when the loop is done
	b startWith2Loop	@ Branch to startWith2Loop to loop until elements don't equal or until the specified string and substring match at the start
	
endStartWith2:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)


@*************************************************************************************************************
@ Subroutine String_endsWith: This method is an external function that accepts the address of a string passed 
@			      in through r0, and a specified suffix passed in r1, Checks whether the string
@			      ends with the specified suffix and returns a boolean result (1 or 0) in r0.
@
@    R0: Points to the address of a string
@    R1: Points to the address of the suffix (substring)
@    LR: Contains the return address
@
@ Returned register contents:
@    R0: Boolean Value ( 1 or 0 ) for if string ends with specified suffix (substring)
@
@ All registers are preserved as per AAPCS
@*************************************************************************************************************

.global String_endsWith		@ Provides function starting address to linker

String_endsWith:		@ Subroutine, external function -> String_endsWith(string1:String,suffix:String):boolean
	push {r4-r11,lr}	@ Preserve working register contents. Save contents of AAPCS registers & LR (pushing data onto stack to store, LIFO)

	mov r4, r0		@ Copy address of the string, r0, to r4
	mov r5, r1		@ Copy address of the suffix (substring), r1, to r5

	bl String_Length	@ Branch and link to String_Length subroutine to get the string length
	mov r6, r0		@ Copy the length of the string to r6

	mov r0, r1		@ Copy address of the suffix to, r1, to r0 in order to find its length
	bl String_Length	@ Branch and link to String_Length subroutine to get the r1 string length
	mov r7, r0		@ Copy the length of the suffix (substring) to r7

	cmp r7, r6		@ Compare r7 and r6, which is the length of substring to the length of the original string
	movgt r0, #0		@ If r7 > r6, if the substring (suffix) is longer in length then, 0 is moved in r0 for the return value
	bgt endEndsWith		@ If r7 > r6, if the substring (suffix) is longer in length then, branch to end of subroutine to return 0

	add r4, r6		@ Adding the length of the string to itself to set starting position for the loop at the last element
	add r5, r7		@ Adding the length of the suffix (substring) to itself to set starting position for the loop at the last element

endWithLoop:			@ Loop condition for iterating backwards through both the string and substring elements to check for their equality
	cmp r7, #0		@ Compare r7, the length of the suffix (substring) being decremented by 1, to 0 to check for when loop is done
	moveq r0, #1		@ If r7 == 0, the whole length of the suffix (substring) has been matched to end, therefore move 1 to r0 for return value
	beq endEndsWith		@ If r7 == 0, the whole length of the suffix (substring) has been matched to end, branch to end of subroutine to return 1

	ldrb r8, [r4], #-1	@ Load byte for each element of r4 (string) to r8, decrementing by 1 to step backwards to the next element
	ldrb r9, [r5], #-1	@ Load byte for each element of r5 (suffix (substring)) to r9, decrementing by 1 to step backwards to the next element

	cmp r8, r9		@ Compare elements of string to elements of (suffix (substring)) to check if they are != for returning 0
	movne r0, #0		@ If r8 != r9, the two elements don't match, therefore move 0 to r0 for the return value
	bne endEndsWith		@ If r8 != r9, the two elements don't match, therefore branch to end of subroutine to return 0

	sub r7, #1		@ r7 = r7 - 1, decrement the length of substring by 1 in order to check for 0 which is when the loop is done
	b endWithLoop		@ Branch to endWithLoop to loop until elements don't equal or until the specified string and substring match at the end

endEndsWith:			@ Condition for the end of the subroutine to pop stack and to return to the calling program
	pop {r4-r11, lr}	@ Restore saved AAPCS & LR register contents (popping off data to retrieve, LIFO)
	bx lr			@ Return to the calling program (branch eXchange)
