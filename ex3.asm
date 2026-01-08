.text

__start:
    li $a0, 8
    li $v0, 9
    syscall

    move $t1, $v0

    li $v0, 5
    syscall

    sw $v0, ($t1)

    li $a0, 8
    li $v0, 9
    syscall

    sw $v0, 4($t1)
    li $v0, 5
    syscall

    lw $t2, 4($t1)
    sw $v0, 4($t2)

    sw $a0, 4($t2)
    li $v0, 1
    syscall

    li $v0, 10
    syscall #woah

.data
