.text
.globl main

main:
    li $a0, 0                   # create dummy node with data value of 0
    jal createNode

    move $s0, $v0               # save memory address of first node to $s0

    li $a0, 8
    move $a1, $s0
    jal insertNode              # insertNode(8, $s0)

    li $a0, 10
    move $a1, $s0
    jal insertNode              # insertNode(10, $s0)

    li $a0, 6
    move $a1, $s0
    jal insertNode              # insertNode(6, $s0)

    li $a0, 5
    move $a1, $s0
    jal insertNode              # insertNode(5, $s0)

    li $a0, 5
    move $a1, $s0
    jal insertNode              # insertNode(5, $s0)

    move $a0, $s0               # print list
    jal printList

    la $a0, end_msg             # print "Program Terminated"
    li $v0, 4
    syscall

    li $v0, 10                  # exit
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
    sub $sp, $sp, 4
    sw $ra, ($sp)


    move $t0, $a0
    #request memory
    li $a0, 8                   # $a0 = 8 => request 8 bytes
    li $v0, 9
    syscall

    sw $t0, ($v0)               #(first 4 bytes of memory requested) = int argument
    sw $zero, 4($v0)            #(last 4 bytes of memory requested) = 0 (terminator)

    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
printList:
# arg $a0 = memory address of first node
# no return value
    sub $sp, $sp, 4
    sw $ra, ($sp)

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

    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
.data
end_msg:  .asciiz "Program terminated!\n"