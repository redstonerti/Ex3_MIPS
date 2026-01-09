.text
.globl main

main:
    li $t0, -1
    li $t1, -1
    li $t2, -1
    li $t3, -1
    li $t4, -1
    li $t5, -1
    li $t6, -1
    li $t7, -1

    li $a0, 8       # $a0 = 8 => request 8 bytes
    li $v0, 9
    syscall

    move $s0, $v0   # save memory address of first node to $s0

    # insertNode(8 (data), $s0 (memory address of first node))
    li $a0, 8
    move $a1, $s0
    jal insertNode

    li $a0, 6
    move $a1, $s0
    jal insertNode

    li $a0, 7
    move $a1, $s0
    jal insertNode

    move $a0, $s0
    jal printList

    la $a0, end_msg # print end_msg
    li $v0, 4
    syscall

    li $v0, 10      # exit
    syscall
printList:
    sub $sp, $sp, 4
    sw $ra, ($sp)
    #arg $a0 = memory address of first node

    move $t0, $a0
printLoop:
    # move to next node (skips first on purpose)
    lw $t1, 4($t0)
    beq $zero, $t1, exitPrintLoop
    lw $t0, 4($t0)

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
    # print newline
    li $a0, '\n'
    li $v0, 11
    syscall

    # no return value
    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
insertNode:
    sub $sp, $sp, 4
    sw $ra, ($sp)
    #arg $a0 = int data value
    #arg $a1 = memory address of first node

    li $v0, 1
    syscall


    move $t1, $a1     # t1 = memory address of first node

    # $v0 (memory address of new node) = createNode($a0)
    jal createNode
    lw $t3, 4($t1)
insertLoop:
    # move to next node (skips first on purpose)
    lw $t2, 4($t1)

    move $t6, $v0
    move $t5, $a0

    la $a0, t3_msg # print t3_msg
    li $v0, 4
    syscall

    move $a0, $t3,        # print t3
    li $v0, 1
    syscall

    li $a0, '\n'        # print new line
    li $v0, 11
    syscall

    move $a0, $t5
    move $v0, $t6

    beq $zero, $t2, addToEnd

    lw $t3, 4($t1)
    lw $t1, 4($t1)

    j insertLoop
addToEnd:
    sw $v0, 4($t1)  # link address of created node ($v0) to end of list (4($t1))
    j exitInsertProcedure
addToMiddle:
    la $a0, loop_msg # print loop_msg
    li $v0, 4
    syscall

    li $v0, 10      # exit
    syscall
exitInsertProcedure:


    move $v0, $a1   #return value $v0 = memory address of first node

    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
createNode:
    sub $sp, $sp, 4
    sw $ra, ($sp)
    #arg $a0 = int data value

    move $t0, $a0
    #request memory
    li $a0, 8       # $a0 = 8 => request 8 bytes
    li $v0, 9
    syscall

    sw $t0, ($v0)         #(first 4 bytes of memory requested) = int argument
    sw $zero, 4($v0)      #(last 4 bytes of memory requested) = 0 (terminator)

    #return value $v0 = memory address of node
    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
.data
end_msg:  .asciiz "Program terminated!\n"
loop_msg: .asciiz "Got to addToMiddle!\n"
t3_msg: .asciiz "\nt3: "