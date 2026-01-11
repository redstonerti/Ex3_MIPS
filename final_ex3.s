	.text
	.globl main

main:
	li $a0, 0                   # create dummy node with data value of 0
    jal createNode
	move $s0, $v0               # save memory address of first node to $s0

Menu_Loop:
	#print(Menu)
	li $v0,4	#print('-------')
	la $a0,space
	syscall
	
	li $v0,4	#print(option1)
	la $a0,insert
	syscall
	
	li $v0,4	#print(option2)
	la $a0,delete
	syscall
	
	li $v0,4	#print(option3)
	la $a0,show
	syscall
	
	li $v0,4	#print(option4)
	la $a0,exit
	syscall
	
	li $v0,4	#print('-------')
	la $a0,space
	syscall

    li $v0,4	#print(choose_an_option)
	la $a0,choose
	syscall

	li $v0,5	#s7 = readInt() //user's choice
	syscall
	move $s7,$v0
	
	beq $s7,$zero,terminate		#if(choice == 0) goto exit
	beq $s7,1,callInsert		#if(choice == 1) goto callInsert
	beq $s7,2,callDelete		#if(choice == 2) goto callDelete
	beq $s7,3,callShow			#if(choice == 3) goto callShow


callInsert:
	li $v0,4	#print("Give value")
	la $a0,enterValue
	syscall
	
	li $v0,5	#a0 = readInt() //int to be inserted
	syscall
	move $a0,$v0
	
	move $a1, $s0		#a1 = head address

	jal insertNode 	#insertNode(int $a0, address $a1)
	#returns head address on $v0
	
	li $v0,4	#print("Value added")
	la $a0,valueAdded
	syscall
	
	j Menu_Loop


callDelete:
	lw $t0,4($s0)	#t0 = dummy_node.next
	beqz $t0,emptyList	#if (t0 == null) goto emptyList
	
	li $v0,4	#print("Give value")
	la $a0,deleteValue
	syscall
	
	li $v0,5	#a0 = readInt() //int to be deleted
	syscall
	move $a0,$v0
	
	move $a1,$s0	#a1 = head address
	
	jal deleteNode
	#returns head address on $v0
	
	j Menu_Loop



callShow:
	lw $t0,4($s0)	#t0 = dummy_node.next
	beqz $t0,emptyList	#if (t0 == null) goto emptyList
	
	move $a0,$s0	#a0 = head address
	jal printList	#else printList()
	
	j Menu_Loop
	

emptyList:
	li $v0,4	#print('The List is empty')
	la $a0,empty
	syscall
	
	j Menu_Loop
	
	
terminate:
    li $v0, 10      # exit
    syscall

insertNode:
# arg $a0 = int data value
# arg $a1 = memory address of first node
# return value $v0 = memory address of first node
    sub $sp, $sp, 4
    sw $ra, ($sp)

    move $t1, $a1               # t1 = memory address of first node

    move $t9, $a0               # save value of $a0 because it will be overwritten
    jal createNode              # $v0 (memory address of new node) = createNode($a0)
    move $a0, $t9               # restore value of $a0

insertLoop:
    lw $t2, ($t1)               # t2 = data value of current node

    blt $a0, $t2, addToMiddle   # if(value to add > value of currentnode), add nodes inbetween

    lw $t3, 4($t1)              # t3 = address current node is pointing to
    beq $zero, $t3, addToEnd    # if(address = 0), add node to end of list

    move $t4, $t1               # save previousNode
    lw $t1, 4($t1)              # advance currentNode
    j insertLoop                # loop

addToEnd:
    sw $v0, 4($t1)              # link address of new node ($v0) to end of list (4($t1))
    j exitInsertProcedure

addToMiddle:
    sw $v0, 4($t4)              # previousNode.next = newNode
    sw $t1, 4($v0)              # newNode.next = currentNode

    j exitInsertProcedure

exitInsertProcedure:
    move $v0, $a1               # set return value

    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
createNode:
# arg $a0 = int data value
# return value $v0 = memory address of node



    move $t0, $a0
    #request memory
    li $a0, 8                   # $a0 = 8 => request 8 bytes
    li $v0, 9
    syscall

    sw $t0, ($v0)               #(first 4 bytes of memory requested) = int argument
    sw $zero, 4($v0)            #(last 4 bytes of memory requested) = 0 (terminator)


    jr $ra
printList:
# arg $a0 = memory address of first node
# no return value


    move $t0, $a0                   # t0 = memory address of first node
printLoop:
    lw $t1, 4($t0)                  # t1 = address currentNode is pointing to
    beq $zero, $t1, exitPrintLoop   # if(address = 0), stop printing
    lw $t0, 4($t0)                  # advance currentNodes

    # print integer
    lw $a0, ($t0)
    li $v0, 1
    syscall

    # print space
    li $a0, ' '
    li $v0, 11
    syscall

    j printLoop
exitPrintLoop:
    li $a0, '\n'                    # print newline
    li $v0, 11
    syscall

    jr $ra

deleteNode:
# arg $a0 = int data value
# arg $a1 = memory address of first node
# return value $v0 = memory address of first node	
	move $t9,$a1	#save address of first node to t9
	
	move $t0,$a1 	#t0 = previous node
	lw	 $t1,4($t0)	#t1 = current node
deleteLoop:
	lw	 $t2,($t1)	#t2 = current node value
	lw 	 $t3,4($t1)	#t3 = currentnode.next
	beq  $t2,$a0,del	#if(currentnode.value == int data value) goto del
	beq  $t3,$zero,notFound	#if(currentnode.next == null) goto notFound
	move $t0,$t1	#new previous = old current
	move $t1,$t3	#new current = old next
	j deleteLoop
	
	
notFound:
	li $v0,4	#print("The value wasn't found")
	la $a0,notFoundmessage
	syscall
	
	move $v0,$t9	#v0 = address of first node
	jr $ra  #return
	
del:
	sw  $t3,4($t0)	#previousnode.next = current.next	
	
	li $v0,4	#print("Value deleted")
	la $a0,valueDeleted
	syscall
	
	move $v0,$t9	#v0 = address of first node
	jr $ra	#return
	


	.data
insert:		.asciiz "(1) Insert data!\n"
delete:		.asciiz "(2) Delete data!\n"
show:		.asciiz "(3) Show list ascending!\n"
exit:		.asciiz "(0) Exit Program!\n"
space:	 	.asciiz "----------------------\n"
choose:		.asciiz "Please choose an option:\n"
empty:		.asciiz "The list is empty.\n"
enterValue:	.asciiz "Enter a value\n"
deleteValue:	.asciiz "Delete a value\n"
valueAdded:	.asciiz "Value added.\n"
valueDeleted:	.asciiz "Value deleted.\n"
notFoundmessage:	.asciiz "The value you entered wasn't found.\n"