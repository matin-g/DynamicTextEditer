/*****************************************************************************************
 * Name:	Milan Bui and Matin Ghaffari
 * Program:	RASM4.s
 * Class:	CS 3B
 * Lab:		RASM4
 * Date:	April 27, 2020 at 3:30 PM
 * Purpose:
 *	Driver for RASM4. Displays a menu allowing you to make changes like a text editor,
 *	saving the resulting text into a file (output.txt) if desired. Able to enter new strings 
 *      manually via keyboard and via a file (input.txt). All additions are additive (calls 2b 5
 *	times and 5 copies of inFile would be stored in the data structure (linked list of strings).
 *	Does not load automatically, only via the menu. Other program functionalities allow
 *	the user to display the entire list, to edit or delete a string at a specified index,
 *	to search and print the nodes with a entered sub string, and save to a output 
 *      file (output.txt). In addition, this program keeps track of the number of bytes
 *	allocated (memory consumption) and the number of nodes in the data structure (linked
 *	list of strings).
 ****************************************************************************************/

.data					@ Directive for the initialized data section

szBuffer:		.skip 512	@ 512 bytes for a string for receiving user input	
szMemory:		.skip 12	@ 12 bytes for a string for the # of bytes consumed
szNodeNum:		.skip 12	@ 12 bytes for a string for the # of nodes in the linked list

iHead:			.word 0		@ NULL pointer used for the head of the linked list
iTail:			.word 0		@ NULL pointer used for the tail of the linked list
iIndex:			.word 0		@ Integer variable used to hold the user input for a desired index to manipulate
iMemory:		.word 0		@ Integer variable used to hold the # of bytes consumed
iNodeNum:		.word 0		@ Integer variable used to hold the # of nodes in the linked list

iInFileHandle:		.word 0		@ Integer variable which is used to address the open input file
iOutFileHandle:		.word 0		@ Integer variable which is used to address the open output file

szInFile:		.asciz "input.txt"
szOutFile:		.asciz "output.txt"
szHeader:		.asciz "\tNames:\t\tMilan Bui & Matin Ghaffari\n\tProgram:\tRASM4.s\n\tClass:\t\tCS 3B\n\tDate:\t\tApril 27, 2020\n\n\n"
szMenuTitle:		.asciz "\t\tRASM4 TEXT EDITOR\n"
szMemoryLabel:		.asciz "\tData Structure Memory Consumption: "
szBytes:		.asciz " bytes"
szNodeNumLabel:		.asciz "\tNumber of Nodes: "
szMenu:			.asciz "\n<1> View all strings\n\n<2> Add string\n\t<a> from Keyboard\n\t<b> from File. Static file named input.txt\n\n<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).\n\n<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n\n<5> String search. Regardless of case, return all strings that match the substring given.\n\n<6> Save file (output.txt)\n\n<7> Quit\n"
szPrompt:		.asciz "What would you like to do? "
szInputPrompt: 		.asciz "Enter a string: "
szSearchPrompt:		.asciz "\nEnter the string you want to search for: "
szIndexPrompt:		.asciz "Enter the index of the string you would like to edit"
szEnterIndexDelete: 	.asciz "Enter the index of the string you would like to delete"
szOpen:			.asciz " (0-"
szClose:		.asciz ")"
szColon:		.asciz ": "
szInvalidIndex:		.asciz "\n*** Invalid index! ***\n\n"
szDeleteEmptyErr:	.asciz "*** CANNOT DELETE FROM AN EMPTY LIST ***\n\n"
szInvalidSel:		.asciz "*** Invalid selection! ***\n\n"
szNoNodes:		.asciz "*** EMPTY LIST, NOTHING TO DISPLAY/EDIT/SEARCH/DELETE ***\n\n"
szNotFound:		.asciz "*** NO MATCHES FOUND ***"
szFileSaved:		.asciz "*** File (output.txt) has been saved with the linked list ***\n\n"
szFileRead:		.asciz "*** File (input.txt) has been read and added to the linked list ***\n\n"

cCr:			.byte 10	@ Character for the line feed to print new line

.text					@ Directive for the text section
	.global _start			@ Provides program starting address to linker
	.extern malloc			@ Using extern directive to provide assembler with malloc c function
	.extern free			@ Using extern directive to provide assembler with free c function

_start:					@ Label for the start of the code
	ldr	r0, =szHeader		@ Loads header
	bl	putstring		@ Prints header

menu:					@ Label for printing out the menu and receiving user input	
	ldr	r0, =szMenuTitle	@ Loads menu title
	bl	putstring		@ Prints menu title
	
	ldr	r0, =szMemoryLabel	@ Loads memory label
	bl	putstring		@ Prints "Data Structure Memory Consumption: "
	ldr	r0, =iMemory		@ Loads iMemory consumption address
	ldr	r0, [r0]		@ Dereferences to get value of bytes consumed
	ldr	r1, =szMemory		@ Loads destination address
	bl	intasc32		@ Converts integer to ascii to display
	
	ldr	r0, =szMemory		@ Loads memory consumption
	bl	putstring		@ Prints memory consumption (in bytes)

	ldr	r0, =szBytes		@ Loads bytes address
	bl	putstring		@ Prints " bytes"
	ldr	r0, =cCr		@ Loads new line
	bl	putch			@ Prints new line

	ldr	r0, =szNodeNumLabel	@ Loads node num label
	bl	putstring		@ Prints "Number of Nodes: "
	ldr	r0, =iNodeNum		@ Loads iNodeNum address
	ldr	r0, [r0]		@ Dereferences to get value of # nodes
	ldr	r1, =szNodeNum		@ Loads destination address
	bl	intasc32		@ Converts number into ascii
	
	ldr	r0, =szNodeNum		@ Loads Node num as ascii
	bl	putstring		@ Prints number of nodes in linked list

	ldr	r0, =cCr		@ Loads new line
	bl	putch			@ Prints new line

	ldr	r0, =szMenu		@ Loads menu address
	bl	putstring		@ Prints menu

	ldr	r0, =cCr		@ Loads new line
	bl	putch			@ Prints new line

	ldr	r0, =szPrompt		@ Loads prompt address
	bl	putstring		@ Prints prompt
	
	ldr	r0, =szBuffer		@ Loads buffer address
	mov	r1, #512		@ Loads max # of bytes from the buffer into r1 (buffer size)
	bl	getstring		@ Obtains user input (selection from menu)

	mov	r4, r0			@ Loads buffer with user input into r4

	ldr 	r0, =cCr		@ Loads new line
	bl 	clear_screen		@ Clears screen using new line
	
	mov	r0, r4			@ Loads buffer into r0
	bl	String_length		@ Finds length of user input
	cmp	r0, #2			@ compares length to #2
	bgt	invalid			@ If length > 2, invalid entry 
	ldrltb	r1, [r4]		@ If length < 2, load single char from buffer into r1
	blt	single_digit_entered	@ and branch to single_digit_entered

	mov	r5, r4			@ Else, load buffer address into r5

	ldrb	r6,[r5], #1		@ Load 1 byte from buffer into r6 and increment address
	cmp	r6, #'2'		@ If r6 != '2'
	bne	invalid			@ Branch to invalid entry (if not equals)
	ldrb	r6, [r5]		@ Else, load next byte into r6 from buffer
	cmp	r6, #'a'		@ If r6 == 'a'
	beq	add_keyboard		@ Branch to add from keyboard (if equals)
	cmp	r6, #'b'		@ Else if r6 == 'b'
	beq	add_file		@ Add from file (if equals)
	bne	invalid			@ Else, invalid entry (if not equals)
	
single_digit_entered:			@ Label for if the user enters a single digit
	cmp	r1, #'1'		@ If user input == '1'
	beq	view_string		@ branch to view string (if equals)
	
	cmp	r1, #'3'		@ If user input == '3'
	beq	delete_string		@ branch to delete string (if equals)

	cmp	r1, #'4'		@ If user input == '4'
	beq	edit_string		@ branch to edit string (if equals)

	cmp	r1, #'5'		@ If user input == '5'
	beq	search_string		@ branch to search string (if equals)

	cmp	r1, #'6'		@ If user input == '6'
	beq	save_file		@ branch to save file (if equals)

	cmp	r1, #'7'		@ If user input == '7'
	beq	quit			@ branch quit (end program) (if equals)

invalid:				@ Label for if the user enters a invalid input
	ldr	r0, =szInvalidSel	@ Load error message
	bl	putstring		@ Print error message
	b	menu			@ Branch to menu to reload the menu

@-----------------------------------------------------------------------------------------------------------	
view_string:				@ Label for the menu choice for printing all strings
	ldr	r0, =iNodeNum		@ Loads iNodeNum address
	ldr	r0, [r0]		@ Dereferences to get # nodes value

	cmp	r0, #0			@ If # nodes == 0
	ldreq	r0, =szNoNodes		@ Load empty list error message (if equals)
	bleq	putstring		@ Prints message (if equals)
	beq	menu			@ Branch to menu to load menu (if equals)

	ldr 	r0, =iHead		@ Else, Loads head address
	ldr 	r0, [r0]		@ Dereferences to get pointer to first node
	ldr 	r1, =iNodeNum		@ Loads iNodeNum address
	ldr 	r1, [r1]		@ Dereferences to get # of nodes
	bl 	displayList		@ Displays strings in the list

	ldr 	r0, =cCr		@ Loads new line
	bl 	putch			@ Prints new line
	
	b 	menu			@ Branch to menu to load menu 

@------------------------------------------------------------------------------------------------------------
add_keyboard:				@ Label for the menu choice of adding a string from the keyboard
	ldr	r0, =szInputPrompt	@ Loads prompts for user input
	bl 	putstring		@ Prints prompt

	ldr	r0, =szBuffer		@ Loads szBuffer address
	mov	r1, #512		@ Loads max # of bytes from the buffer into r1 (buffer size)
	bl	getstring		@ Gets user input 

	bl	String_copy		@ Copies string
	mov 	r3, r0			@ Loads copy into r3

	bl	String_length		@ Gets length of string (byte consumption)
	add	r0, #1			@ Adds 1 byte for NULL

	ldr 	r5, =iMemory		@ Load iMemory address
	ldr 	r4, [r5]		@ Dereferences to get value for byte consumption
	add 	r4, #8			@ Adds 8 bytes to memory for the node
	add	r4, r0			@ Adds # bytes of string into memory
	str 	r4, [r5]		@ Stores memory value

	ldr 	r1, =iHead		@ Loads head address
	ldr 	r1, [r1]		@ Dereferences to get pointer to first node
	ldr 	r2, =iTail		@ Loads tail address
	ldr 	r2, [r2]		@ Dereferences to get tail ptr of list
	bl 	newNode			@ Creates new node (adds to list)

	ldr 	r3, =iHead		@ Loads head address
	str 	r1, [r3]		@ Stores new head address
	ldr 	r3, =iTail		@ Loads tail address
	str 	r2, [r3]		@ Stores new tail address
	
	ldr 	r3, =iNodeNum		@ Loads iNodeNum address
	ldr 	r4, [r3]		@ Dereferences to get value of # of nodes
	add 	r4, #1			@ Increments node num by 1
	str 	r4, [r3]		@ Stores new value for # nodes

	ldr 	r0, =cCr		@ Loads new line
	bl 	clear_screen		@ Clears screen using new line

	b	menu			@ Branch to menu to load menu

@------------------------------------------------------------------------------------------------------------
add_file:				@ Label for the menu choice of adding from the input file
	ldr	r0, =szInFile		@ File name
	mov	r1, #00			@ Flag = read ONLY
	mov	r2, #0644		@ Mode = read/write us, others only read
	mov	r7, #5			@ Open File
	svc	0			@ Used to transition to kernel mode

	ldr	r1, =iInFileHandle	@ Loads iInFileHandle address
	str	r0, [r1]		@ Stores file handle for input file
	ldr	r4, =szBuffer		@ Loads buffer address into r4
	
read_file:				@ Label for the loop that reads from the input file
	ldr	r0, =iInFileHandle	@ Input file handle address
	ldr	r0, [r0]		@ Dereferences to get input file handle value
	ldr	r1, =szBuffer		@ Loads buffer (where chars from input file gets read into)
	
	bl	getline			@ Gets 1 line (string) from the input file
	cmp	r1,#-1 			@ If r1 == NULL
	moveq	r5, r1			@ Load r1 into r5 (reached end of file)

	bl	String_copy		@ Gets a copy of what is in buffer
	mov 	r3, r0			@ Moves this address into r3

	bl	String_length		@ Gets length of string (byte consumption)
	add	r0, #1			@ Adds 1 byte for NULL

	ldr 	r6, =iMemory		@ Load iMemory address
	ldr 	r4, [r6]		@ Dereferences to get value for byte consumption
	add 	r4, #8			@ Adds 8 bytes to memory for the node
	add	r4, r0			@ Adds # bytes of string into memory
	str 	r4, [r6]		@ Stores memory value
			
	ldr 	r1, =iHead		@ Loads iHead address
	ldr 	r1, [r1]		@ Dereferences to get pointer to first node
	ldr 	r2, =iTail		@ Loads iTail address
	ldr 	r2, [r2]		@ Dereferences to get tail ptr of list
	bl 	newNode			@ Create new node for new string (add to list)

	ldr	r3, =iHead		@ Load head address
	str 	r1, [r3]		@ Store new head into head
	ldr 	r3, =iTail		@ Load tail address
	str	r2, [r3]		@ Store new tail into tail

	ldr	r3, =iNodeNum		@ Load iNodeNum address
	ldr 	r4, [r3]		@ Dereference to get node num value
	add 	r4, #1			@ Increment node num by 1
	str 	r4, [r3]		@ Store new node num value
	
	cmp	r5, #-1			@ If r5 != NULL
	bne	read_file		@ Continue reading input file
	
end_file:				@ Label for the end of reading from the input file
	ldr	r0, =iInFileHandle	@ input file handle
	mov	r7, #6			@ Closes input file
	svc	0			@ Supervisor call set to 0
	
	ldr	r0, =szFileRead		@ Load into r0 a string for indicating the file has been read and added to list
	bl	putstring		@ Displays a string to the terminal indicating the file has been read and added to list	

	b 	menu			@ Branch to menu to load menu

@------------------------------------------------------------------------------------------------------------
delete_string:				@ Label for the menu option of deleting a string
	ldr	r0, =iNodeNum		@ Loads iNodeNum address
	ldr	r0, [r0]		@ Dereferences to get # of nodes value
	
	cmp 	r0, #0			@ Compare the number of nodes to 0 to check for an empty list
	ldreq 	r0, =szDeleteEmptyErr	@ Load into r0, if # nodes == 0, the delete from empty list message
	bleq 	putstring		@ Branch and link if equal to display a message for deleting from an empty list
	beq 	menu			@ If # nodes = 0 branch back to the menu

	mov	r1, r0			@ Move number of nodes into r1 for checking for multiple nodes

	ldr	r0, =szEnterIndexDelete	@ Loads the prompt address for prompting for the index #
	bl	putstring		@ Prints prompt

	cmp	r1, #1			@ If # nodes != 1
	bne	mult_nodesDelete	@ Branch to mult_nodesDelete if # nodes != 1

contDelete:				@ Label for continuing with the delete condition
	ldr	r0, =szColon		@ Loads colon
	bl	putstring		@ Prints ": "
	
	ldr	r0, =szBuffer		@ Loads buffer address
	mov	r1, #512		@ Loads max # of bytes from the buffer into r1 (buffer size)
	bl	getstring		@ Obtains user input (selection for index)
	
	ldr 	r0, =szBuffer		@ Loads buffer address
	bl	ascint32		@ Converts string of characters to equivalent 4-byte value
	
	ldr 	r1, =iIndex		@ Load into r1 the address iIndex
	str	r0, [r1]		@ Storing value of r0 (index) to the address in r1 (iIndex)

	ldr	r0, =iNodeNum		@ Loads iNodeNum address
	ldr	r0, [r0]		@ Dereferences to get # of nodes
	
	ldr 	r3, =iIndex		@ Load into r3 the address iIndex
	ldr 	r3, [r3]		@ Dereferences to get the index value

	cmp	r3, #0			@ Compare the index value to 0 to check for validity
	blt 	invalidIndex		@ Branch if index < 0, to a condition that prints an invalid index error message

	sub 	r0, #1			@ Subtract the number of nodes by 1 to check if the index is within the top index

	cmp 	r3, r0			@ Compare the user's index to the max index value
	bgt 	invalidIndex		@ If user's index is greater than max index branch to a condition that prints an index error message

	ldr 	r1, =iHead		@ Loads head address
	ldr	r1, [r1]		@ Dereferences to get pointer to first node
	ldr 	r2, =iTail		@ Loads tail address
	ldr	r2, [r2]		@ Dereferences to get tail ptr of list
	bl 	deleteString		@ Branch and link to the subroutine that deletes the specified index
	mov 	r5, r0			@ Move r0 (the number of bytes deallocated for data segment string) into r5 (string_Length of data)

	ldr 	r3, =iHead		@ Loads head address
	str 	r1, [r3]		@ Stores new head address
	ldr 	r3, =iTail		@ Loads tail address
	str 	r2, [r3]		@ Stores new tail address

	ldr 	r3, =iNodeNum		@ Loads iNodeNum address
	ldr 	r4, [r3]		@ Dereferences to get value
	sub 	r4, #1			@ Decrements node num by 1
	str 	r4, [r3]		@ Stores new value for the number of nodes

	ldr 	r3, =iMemory		@ Loads iMemory address
	ldr 	r4, [r3]		@ Dereferences to get memory consumption value
	sub 	r4, #9			@ Subtract 9 (8 for the node + 1 for the null = 9)
	sub 	r4, r5			@ Subtract the bytes deallocated for the data segment (string length of data)
	str	r4, [r3]		@ Stores new value for memory consumption	

	ldr 	r0, =cCr		@ Loads new line
	bl 	clear_screen		@ Clears screen using new line

	b 	menu			@ Branch to the menu of the program to re-prompt the menu

mult_nodesDelete:			@ Label for if the number of nodes is != 1 for printing index range
	ldr	r0, =szOpen		@ Loads open parentheses
	bl	putstring		@ Prints " (0-"	
	sub	r1, #1			@ Subtracts 1 from index
	mov	r0, r1			@ Loads max index into r0
	ldr	r1, =szNodeNum		@ Loads szNodeNum address
	bl	intasc32		@ Converts int to ascii and stores in szNodeNum
	ldr	r0, =szNodeNum		@ Loads szNodeNum
	bl	putstring		@ Prints max index (# nodes - 1)
	ldr	r0, =szClose		@ Loads szClose
	bl	putstring		@ Prints ")"
	b	contDelete 		@ After printing prompt branch to contDelete to continue delete string condition

invalidIndex:				@ Label for if the user input is not a valid index
	ldr	 r0, =szInvalidIndex	@ Load into r0 the string for if there is an invalid index
	bl 	putstring		@ Print to the terminal the invalid index message	

	b 	delete_string		@ Branch back to delete condition to re-prompt the user for another index until valid

@------------------------------------------------------------------------------------------------------------
edit_string:				@ Label for the menu option of editing a string
	ldr	r1, =iNodeNum		@ Loads iNodeNum address
	ldr	r1, [r1]		@ Dereference to get # of nodes value

	cmp	r1, #0			@ If List is empty
	ldreq	r0, =szNoNodes		@ Load error message (if equal)
	bleq	putstring		@ Prints message (if equal)
	beq	menu			@ Branch to menu (if equal)

	ldr	r0, =szIndexPrompt	@ Loads prompts for user input (index of node)
	bl 	putstring		@ Prints prompt
	
	cmp	r1, #1			@ If # nodes != 1
	bne	mult_nodesEdit		@ Branch to mult_nodesEdit if # nodes != 1

contEdit:				@ Label for continuing with the edit condition
	ldr	r0, =szColon		@ Loads colon
	bl	putstring		@ Prints ": "

	ldr	r0, =szBuffer		@ Loads szBuffer address
	mov	r1, #512		@ Loads max # of bytes from the buffer into r1 (buffer size)
	bl	getstring		@ Gets user input

	bl	ascint32		@ Converts input to integer
	mov	r2, r0			@ Moves converted index into r2

	cmp	r2, #0			@ Compare the index value to 0 to check for validity
	blt 	invalidIndex		@ Branch if index < 0, to a condition that prints an error message

	ldr	r0, =iNodeNum		@ Loads iNodeNum address
	ldr	r0, [r0]		@ Dereference to get # of nodes
	cmp	r2, r0			@ If selected index >= num of nodes
	bge	invalid_index		@ Branch to error message (if greater than)
	
	ldr	r0, =szInputPrompt	@ Loads prompts for user input
	bl 	putstring		@ Prints prompt

	ldr	r0, =szBuffer		@ Loads szBuffer address
	mov	r1, #512		@ Loads max # of bytes from the buffer into r1 (buffer size)
	bl	getstring		@ Gets user input 
	
	mov	r3, r0			@ Moves buffer address (address of string) into r3

	ldr 	r0, =iHead		@ Loads head address
	ldr 	r0, [r0]		@ Dereferences to obtain pointer to the first node
	ldr 	r1, =iNodeNum		@ Loads iNodeNum address
	ldr 	r1, [r1]		@ Dereferences to get # of nodes value
	bl	editString		@ Replaces the string at the given index

	ldr 	r6, =iMemory		@ Load iMemory address
	ldr 	r4, [r6]		@ Dereferences to get value of byte consumption
	sub 	r4, r0			@ Subtracts bytes of original string
	add	r4, r1			@ Adds # bytes of new string
	str 	r4, [r6]		@ Stores memory value

	ldr 	r0, =cCr		@ Loads new line
	bl 	clear_screen		@ Clears screen using new line

	b 	menu			@ Branch to the menu of the program to re-prompt the menu

mult_nodesEdit:				@ Label for if the number of nodes is != 1 for printing index range
	ldr	r0, =szOpen		@ Loads open parentheses
	bl	putstring		@ Prints " (0-"	
	sub	r1, #1			@ Subtracts 1 from index
	mov	r0, r1			@ Loads max index into r0
	ldr	r1, =szNodeNum		@ Loads szNodeNum address
	bl	intasc32		@ Converts int to ascii and stores in szNodeNum
	ldr	r0, =szNodeNum		@ Loads szNodeNum
	bl	putstring		@ Prints max index (# nodes - 1)
	ldr	r0, =szClose		@ Loads szClose
	bl	putstring		@ Prints ")"
	b	contEdit 		@ After printing prompt branch to contEdit to continue edit string condition

invalid_index:				@ Label for printing an invalid index message
	ldr	r0, =szInvalidIndex	@ Load error message
	bl	putstring		@ Print error message
	b	edit_string		@ Branch to reload prompt for the index until the index is valid

@------------------------------------------------------------------------------------------------------------
search_string:				@ Label for the menu option of searching a string with a given sub string
	ldr	r1, =iNodeNum		@ Loads iNodeNum address
	ldr	r1, [r1]		@ Dereference to get # of nodes value

	cmp	r1, #0			@ If List is empty
	ldreq	r0, =szNoNodes		@ Load error message (if equal)
	bleq	putstring		@ Prints message (if equal)
	beq	menu			@ Branch to menu (if equal)
	
	ldr	r0, =szSearchPrompt	@ Prompts user for input (sub string)
	bl	putstring		@ Prints prompt for search key sub string

	ldr	r0, =szBuffer		@ Loads szBuffer address
	mov	r1, #512		@ Loads max # of bytes from the buffer into r1 (buffer size)
	bl	getstring		@ Gets user input 
	mov	r2, r0			@ Loads input (buffer) into r2

	ldr	r0, =cCr		@ Loads cCr (new line)
	bl	putch			@ Prints new line

	ldr 	r0, =iHead		@ Loads head address
	ldr 	r0, [r0]		@ Dereferences to obtain pointer to the first node
	ldr 	r1, =iNodeNum		@ Loads iNodeNum address
	ldr 	r1, [r1]		@ Dereferences to get # of nodes value
	bl	searchList		@ Searches list and displays any string containing the search key

	cmp	r0, #-1			@ If r0 == -1 (match not found)
	ldreq	r0, =szNotFound		@ Loads not found message (if equal)
	bleq	putstring		@ Displays not found message (if equal)

	ldr	r0, =cCr		@ Loads cCR (new line)
	bl	putch			@ Prints new line

	b 	menu			@ Branch to the menu of the program to re-prompt the menu

@------------------------------------------------------------------------------------------------------------
save_file:				@ Label for the menu option of saving the file to output.txt
	ldr	r0, =szOutFile		@ File name
	mov	r1, #01101		@ Flag = write ONLY & Truncate existing file (delete all contents)
	mov	r2, #0644		@ Mode = read/write
	mov	r7, #5			@ Open File
	svc	0			@ Supervisor call set to 0

	ldr	r1, =iOutFileHandle	@ Output file handle address
	str	r0, [r1]		@ Stores file handle for output file

	ldr	r0, =iNodeNum		@ Loads iNodeNum address
	ldr	r0, [r0]		@ Dereferences to get value for the # of nodes
	cmp	r0, #0			@ If # of nodes == 0
	beq	close_out_file		@ Load menu (if equal)

	ldr 	r0, =iHead		@ Loads head address
	ldr	r0, [r0]		@ Dereferences to get pointer to first node  
	ldr	r1, =iNodeNum		@ Loads iNodeNum address
	ldr	r1, [r1]		@ Dereferences to get the value for the # of nodes
	ldr	r2, = iOutFileHandle	@ Loads outFileHandle address
	ldr	r2, [r2]		@ Dereferences to get file handle for output file
	bl 	save_list		@ Saves linked list to output file

close_out_file:				@ Label for closing the output file
	ldr	r0, =iOutFileHandle	@ output file handle
	mov	r7, #6			@ Closes output file
	svc	0			@ Supervisor call set to 0

	ldr	r0, =szFileSaved	@ Load into r0 a string for indicating the file has been saved
	bl	putstring		@ Displays a string to the terminal indicating the file has been saved	

	b	menu			@ Branch to the menu of the program to re-prompt the menu
		
@-----------------------------------------------------------------------------------------------------
quit:					@ Label for the menu option of exiting the program
	ldr	r1, =iNodeNum		@ Loads iNodeNum address
	ldr	r1, [r1]		@ Dereference to get # of nodes value
	
	cmp	r1, #0			@ If List is empty
	beq 	doneDeallocating	@ Branch if equal to condition for terminating the program

	sub 	r1, #1			@ Subtract 1 from the number of nodes to get the highest index value
	mov 	r5, r1			@ Move the max index value into r5 to initialize the loop counter for deleting entire list

deleteAllLoop:				@ If the list is not empty then delete the entire list
	ldr 	r1, =iHead		@ Loads head address
	ldr	r1, [r1]		@ Dereferences to get pointer to first node
	ldr 	r2, =iTail		@ Loads tail address
	ldr	r2, [r2]		@ Dereferences to get tail pointer
	mov	r3, r5			@ Move into r3 the current index be deleted starting from the max index
	bl 	deleteString		@ Branch and link to deleteString that specific string at that index
	mov	r6, r0			@ Move r0 (the number of bytes deallocated for data segment string) into r6

	ldr 	r3, =iHead		@ Loads head address
	str 	r1, [r3]		@ Stores new head address
	ldr 	r3, =iTail		@ Loads tail address
	str 	r2, [r3]		@ Stores new tail address

	ldr 	r3, =iNodeNum		@ Loads iNodeNum address
	ldr 	r4, [r3]		@ Dereferences to get value for # nodes
	sub 	r4, #1			@ Decrements node num value by 1
	str 	r4, [r3]		@ Stores new value for node num

	ldr 	r3, =iMemory		@ Loads iMemory address
	ldr 	r4, [r3]		@ Dereferences to get memory consumption
	sub 	r4, #9			@ Subtract 9 (8 for the node + 1 for the null = 9)
	sub 	r4, r6			@ Subtract the bytes deallocated for the data segment (string length of data)
	str 	r4, [r3]		@ Stores new value
	
	cmp 	r5, #0			@ Compare current index to 0 to check if the last index (0) has been deleted
	beq 	doneDeallocating	@ If index 0 has been deleted (if equals) then branch to the condition that terminates the program

	sub 	r5, #1			@ If there are still nodes remaining subtract loop counter by 1 to move to next string to delete
	b 	deleteAllLoop		@ Branch to loop condition that deletes all strings until there are no nodes left

doneDeallocating:			@ Condition for terminating the program once the entire list has been deleted
	mov	r0, #0			@ Exit Status code set to 0 indicates "normal completion"
	mov	r7, #1			@ Service command code (1) will terminate this program
	svc	0			@ Issue Linux command to terminate program.

	.end				@ Directive for the end of code
