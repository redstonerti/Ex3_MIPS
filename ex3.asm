.text
.globl main

main:
    jal request_mem

    move $t0, $v0   # $t0 = $v0

    li $v0, 5       # $v0 = readInt()
    syscall

    sw $v0, ($t0)   # (first 4 bytes of memory location $t0 is pointing to) = integer read

    jal request_mem

    sw $v0, 4($t0)  # (last 4 bytes of memory location $t0 is pointing to) = $v0 = memory location of next node

    li $t1, 9       # $t1 = 9
    lw $t2, 4($t0)  # $t2 = pointer of first node = address of second node
    sw $t1, ($t2)   # data of first node = $t1

    la $a0, end_msg
    li $v0, 4
    syscall

    li $v0, 10      # exit
    syscall

request_mem:
    sub $sp, $sp, 4
    sw $ra, ($sp)

    li $a0, 8       # $a0 = 8 => request 8 bytes
    li $v0, 9
    syscall         # $v0 = memory address of the space requested

    j return        # go to return address
return:
    lw $ra, ($sp)
    add $sp, $sp, 4
    jr $ra
.data
end_msg:  .asciiz "Program terminated!\n"