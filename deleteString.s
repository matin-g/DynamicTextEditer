/*****************************************************************************************
 * Name    : Milan Bui and Matin Ghaffari
 * Program : deleteString.s
 * Lab     : RASM 4
 * Class   : CS3B MW 3:30p-5:50p
 * Date    : 4/15/2020
 * Contract:
 * This subroutine accepts three arguments: headPtr (R1), tailPtr (R2), index of node to
 * delete (R3). Deallocates the node in the linked list corresponding to the index
 * entered by the user and returns the updated head and tail pointers and the string
 * length of the data deallocated.
 *	R1: Pointer to head of linked list
 *	R2: Pointer to tail of linked list
 *	R3: The index of the node to delete
 *	LR: Return address
 * Returns:
 *      R0: The string length of the data deallocated
 *	R1: The updated head pointer
 *	R2: The updated tail pointer
 * AAPCS Compliant
 ****************************************************************************************/

.data					@ Directive for the initialized data section

iNext:	.word 0				@ Pointer initialized to NULL, used for the next node

.text					@ Directive for the text section
	.global deleteString		@ Provides subroutine starting address to linker
	.extern free			@ Using extern directive to provide assembler with free c function
	
deleteString:				@ Label for the start of the delete string subroutine
	push 	{r4-r11, lr}		@ Push AAPCS required registers and link register to preserve values

	mov 	r9, #0			@ Initialize r9 to 0 for the string length of the deallocated data

	ldr 	r8, =iNodeNum		@ Load the address of the number of nodes into r8
	ldr 	r8, [r8]		@ Dereference to get the value for the number of nodes

	cmp 	r8, #1			@ Check to see if item being deleted is the last item
	moveq 	r0, r1			@ If iNodeNum == 1, move head to r0
	ldreq 	r0, [r0]		@ If iNodeNum == 1, dereference head pointer for finding string length
	bleq 	String_length		@ If iNodeNum == 1, get the data string length
	moveq 	r9, r0			@ If iNodeNum == 1, hold length value in r9
	beq 	clearList		@ If it is the last item branch to clearList (iNodeNum == 1)

	cmp 	r3, #0			@ Check index to see if we are deleting from the head (list with greater than 1 node)
	moveq 	r0, r1			@ If index == 0, move head to r0
	ldreq	r0, [r0]		@ If index == 0, dereference head pointer for finding string length
	bleq 	String_length		@ If index == 0, get the data string length
	moveq	r9, r0			@ If index == 0, hold length value in r9
	beq	deleteHead		@ If index is 0 (head position) and # nodes > 1 branch to delete from head
	
	mov 	r4, #1			@ If index != head, initialize the loop counter to 1
	mov 	r5, r1			@ Move head to r5

goToIndex:				@ Label for traversing to the specified index
	mov 	r6, r5			@ Move r5 into r6 for the previous node
	ldr 	r5, [r5, #4]		@ Point head to the next node

	cmp 	r4, r3			@ Check if index is found
	moveq 	r0, r5			@ If index is found, move node to r0
	ldreq 	r0, [r0]		@ If index is found, dereference the pointer for finding string length
	bleq 	String_length		@ If index is found, get the data string length
	moveq 	r9, r0			@ If index is found, hold length value in r9
	beq 	delete			@ Branch to delete condition for deleting node that isn't the head

	add 	r4, #1			@ Increment counter used to find the node at the given index
	b 	goToIndex		@ Branch to loop until the given index has been reached in the list

deleteHead:				@ Label for deleting the head when there is more than 1 index
	ldr 	r10, [r1]		@ Move the data (head's string) into r10
	mov 	r0, r10			@ Move the data of the head node into r0 for deallocation
	push 	{r1-r2}			@ Push r1 and r2 to preserve values
	bl 	free			@ Deallocate head's string (data)
	pop	{r1-r2}			@ Pop r1 and r2 to restore values

	mov 	r0, r1			@ Move the head into r0 for deallocation
	ldr 	r1, [r1, #4]		@ Point head to the next node

	ldr 	r11, =iNext		@ Load into r11 the address of iNext
	str 	r1, [r11]		@ Store address of the next node

	push 	{r1-r2}			@ Push r1 and r2 to preserve values
	bl 	free			@ Deallocate head node
	pop 	{r1-r2}			@ Pop r1 and r2 to restore values

	ldr 	r1, =iNext		@ Load into r1 the address of iNext
	ldr 	r1, [r1]		@ Load next node into head

	b 	endDeleteStr		@ Branch to the end of this subroutine

delete:					@ Label for the condition of deleting a index other than the head or the only item
	ldr 	r10, [r5]		@ Move the data (string of the node) into r10
	mov 	r0, r10			@ Move the data of the node into r0 for deallocation
	push 	{r1-r2}			@ Push r1 and r2 to preserve values
	bl 	free			@ Deallocate the string (data) of the node
	pop 	{r1-r2}			@ Pop r1 and r2 to restore values
	
	ldr 	r7, [r5, #4]		@ Get address of next node into r7

	mov	r0, r5			@ Move the address of the node into r0 for deallocation
	push	{r1-r2}			@ Push r1 and r2 to preserve values
	bl 	free			@ Deallocate node
	pop	{r1-r2}			@ Pop r1 and r2 to restore value
	
	cmp	r7, #0			@ If the next node is null
	moveq	r2, r6			@ Move the previous node into tail

	str	r7, [r6, #4]		@ Store previous node into current node's next

	b	endDeleteStr		@ Branch to the end of this subroutine

clearList:				@ Label for the condition that the only item in the list is being deleted
	ldr	r10, [r1]		@ Move the data (string of only node) into r10
	mov 	r0, r10			@ Move the data of the node into r0 for deallocation
	push 	{r1}			@ Push r1 to preserve head value
	bl 	free			@ Deallocate the head's string (data)
	pop 	{r1}			@ Pop r1 to restore head value

	mov 	r0, r1			@ Move the node being deleted into r0 for free
	bl 	free			@ Deallocate the only node in the list
	
	mov 	r1, #0			@ Move 0 (NULL) into r1

	ldr 	r4, =iHead		@ Load into r4 the address of iHead
	ldr 	r4, [r4]		@ Dereferences address of head to get the node
	str 	r1, [r4]		@ Store NULL in the head node

	ldr 	r4, =iTail		@ Load into r4 the address of iTail
	ldr 	r4, [r4]		@ Dereferences address of tail to get the node
	str 	r1, [r4]		@ Store NULL in the tail node
	
endDeleteStr:				@ Label for the end of the delete string subroutine
	mov 	r0, r9			@ Move the value of the string length of the data deallocated to r0 to be returned

	pop 	{r4-r11, lr}		@ Pop AAPCS required registers and link register to restore values
	bx 	lr			@ Branch Exchange to return to caller
