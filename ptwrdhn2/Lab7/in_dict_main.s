.data

# Strings for printing purposes
in_dict_empty_str: .asciiz "in_dict(\"\", test_dict, 3) is "
in_dict_a_str: .asciiz "in_dict(\"a\", test_dict, 3) is "
in_dict_abc_str: .asciiz "in_dict(\"abc\", test_dict, 3) is "
in_dict_c_str: .asciiz "in_dict(\"c\", test_dict, 3) is "

# Dictionary
test_dict: .word a_str ab_str abc_str
a_str: .asciiz "a"
ab_str: .asciiz "ab"
abc_str: .asciiz "abc"
TEST_DICT_LEN = 3

# Other string literals
empty_str: .asciiz ""
c_str: .asciiz "c"

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, in_dict_empty_str
	jal	print_string
	la	$a0, empty_str
	la	$a1, test_dict
	li	$a2, TEST_DICT_LEN
	jal	in_dict
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, in_dict_a_str
	jal	print_string
	la	$a0, a_str
	la	$a1, test_dict
	li	$a2, TEST_DICT_LEN
	jal	in_dict
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, in_dict_abc_str
	jal	print_string
	la	$a0, abc_str
	la	$a1, test_dict
	li	$a2, TEST_DICT_LEN
	jal	in_dict
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, in_dict_c_str
	jal	print_string
	la	$a0, c_str
	la	$a1, test_dict
	li	$a2, TEST_DICT_LEN
	jal	in_dict
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
