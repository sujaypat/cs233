.data

# Strings for printing purposes
length_0x0_str: .asciiz "length(0x0) is "
length_0x1_str: .asciiz "length(0x1) is "
length_0x2_str: .asciiz "length(0x2) is "
length_0x7_str: .asciiz "length(0x7) is "
length_0x4d0_str: .asciiz "length(0x4d0) is "
length_0xd_str: .asciiz "length(0xd) is "

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, length_0x0_str
	jal	print_string
	li	$a0, 0x0
	jal	length
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, length_0x1_str
	jal	print_string
	li	$a0, 0x1
	jal	length
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, length_0x2_str
	jal	print_string
	li	$a0, 0x2
	jal	length
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, length_0x7_str
	jal	print_string
	li	$a0, 0x7
	jal	length
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, length_0x4d0_str
	jal	print_string
	li	$a0, 0x4d0
	jal	length
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, length_0xd_str
	jal	print_string
	li	$a0, 0xd
	jal	length
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
