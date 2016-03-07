.data

# Strings for printing purposes
sub_str_empty_str: .asciiz "sub_str(\"\", 0) is "
sub_str_a_str: .asciiz "sub_str(\"a\", 1) is "
sub_str_ab_str: .asciiz "sub_str(\"abc\", 2) is "
sub_str_abc_str: .asciiz "sub_str(\"abc\", 4) is "

# Other string literals
empty_str: .asciiz ""
a_str: .asciiz "a"
ab_str: .asciiz "ab"
abc_str: .asciiz "abc"

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, sub_str_empty_str
	jal	print_string
	la	$a0, empty_str
	la	$a1, 0
	jal	sub_str
	move	$a0, $v0
	jal	print_string
	jal	print_newline

	la	$a0, sub_str_a_str
	jal	print_string
	la	$a0, a_str
	la	$a1, 1
	jal	sub_str
	move	$a0, $v0
	jal	print_string
	jal	print_newline

	la	$a0, sub_str_ab_str
	jal	print_string
	la	$a0, ab_str
	la	$a1, 2
	jal	sub_str
	move	$a0, $v0
	jal	print_string
	jal	print_newline

	la	$a0, sub_str_abc_str
	jal	print_string
	la	$a0, abc_str
	la	$a1, 4
	jal	sub_str
	move	$a0, $v0
	jal	print_string
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra