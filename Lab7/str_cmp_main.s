.data

# Strings for comparing
# Put in random order to catch student errors
this_str1: .asciiz "this is a string!"
b_str2: .asciiz "b"
a_str1: .asciiz "a"
ab_str1: .asciiz "ab"
b_str1: .asciiz "b"
a_str2: .asciiz "a"
this_str2: .asciiz "this is a string!"
empty_str1: .asciiz ""
ab_str2: .asciiz "ab"
empty_str2: .asciiz ""

# Strings for printing purposes
str_cmp_empty_str: .asciiz "str_cmp(\"\", \"\") is "
str_cmp_a_str: .asciiz "str_cmp(\"a\", \"\") is "
str_cmp_a_str2: .asciiz "str_cmp(\"a\", \"a\") is "
str_cmp_b_str: .asciiz "str_cmp(\"\", \"b\") is "
str_cmp_b_str2: .asciiz "str_cmp(\"b\", \"b\") is "
str_cmp_aab_str: .asciiz "str_cmp(\"a\", \"ab\") is "
str_cmp_aba_str: .asciiz "str_cmp(\"ab\", \"a\") is "
str_cmp_abab_str: .asciiz "str_cmp(\"ab\", \"ab\") is "
str_cmp_this_str: .asciiz "str_cmp(\"this is a string\", \"this is a string\") is "

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, str_cmp_empty_str
	jal	print_string
	la	$a0, empty_str1
	la	$a1, empty_str2
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_a_str
	jal	print_string
	la	$a0, a_str1
	la	$a1, empty_str1
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_a_str2
	jal	print_string
	la	$a0, a_str1
	la	$a1, a_str2
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_b_str
	jal	print_string
	la	$a0, empty_str1
	la	$a1, b_str1
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_b_str2
	jal	print_string
	la	$a0, b_str2
	la	$a1, b_str1
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_aab_str
	jal	print_string
	la	$a0, a_str1
	la	$a1, ab_str1
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_aba_str
	jal	print_string
	la	$a0, ab_str1
	la	$a1, a_str1
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_abab_str
	jal	print_string
	la	$a0, ab_str1
	la	$a1, ab_str2
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	la	$a0, str_cmp_this_str
	jal	print_string
	la	$a0, this_str1
	la	$a1, this_str2
	jal	str_cmp
	move	$a0, $v0
	jal	print_int_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
