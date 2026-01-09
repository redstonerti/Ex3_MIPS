.text
.globl main

main:
    li $a0, 8       # $a0 = 8 => request 8 bytes
    li $v0, 9
    syscall

    move $s0, $v0   # save memory address of first node to $s0

    # insertNode(78 (data), $s0 (memory address))
    li $a0, 78
    move $a1, $s0
    jal insertNode

    la $a0, end_msg # print end_msg
    li $v0, 4
    syscall

    li $v0, 10      # exit
    syscall
insertNode:
    sub $sp, $sp, 4
    sw $ra, ($sp)
    #arg $a0 = int data value
    #arg $a1 = memory address of first node

    move $t4, $a1

    jal createNode
loop:
   lw $t6, 4($t4)
   beq $zero, $t6, exit_loop
   lw $t4, 4($t4)
   j loop
exit_loop:
    sw $v0, 4($t4)

    move $v0, $a1

    #return value $v0 = memory address of first node
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