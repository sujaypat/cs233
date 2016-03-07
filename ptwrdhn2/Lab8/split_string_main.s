.data
sol_memory: .space 256

# Dictionaries
dict1: .word 2 hello_str world_str
hello_str: .asciiz "hello"
world_str: .asciiz "world"

dict2: .word 3 a_str bb_str cccc_str
a_str: .asciiz "a"
bb_str: .asciiz "bb"
cccc_str: .asciiz "cccc"

# Other string literals
longstring1: .asciiz "helloworld"
longstring2: .asciiz "aaaabbbbcccc"
longstring3: .asciiz "bbb"


.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, sol_memory
	la	$a1, longstring1
	la	$a2, dict1
	jal	split_string
	move $a0, $v0
	jal	print_int_and_space

	la	$a0, sol_memory
	lw 	$a0, 0($a0)
	jal print_string
	jal print_space

	la	$a0, sol_memory
	lw 	$a0, 4($a0)
	jal print_string
	jal	print_newline

	la	$a0, sol_memory
	la	$a1, longstring2
	la	$a2, dict2
	jal	split_string
	move $a0, $v0
	jal	print_int_and_space

	la	$a0, sol_memory
	lw 	$a0, 0($a0)
	jal print_string
	jal	print_space

	la	$a0, sol_memory
	lw 	$a0, 4($a0)
	jal print_string
	jal	print_space

	la	$a0, sol_memory
	lw 	$a0, 8($a0)
	jal print_string
	jal	print_space

	la	$a0, sol_memory
	lw 	$a0, 12($a0)
	jal print_string
	jal	print_space

	la	$a0, sol_memory
	lw 	$a0, 16($a0)
	jal print_string
	jal	print_space

	la	$a0, sol_memory
	lw 	$a0, 20($a0)
	jal print_string
	jal	print_space

	la	$a0, sol_memory
	lw 	$a0, 24($a0)
	jal print_string
	jal	print_newline

	la	$a0, sol_memory
	la	$a1, longstring3
	la	$a2, dict2
	jal	split_string
	move $a0, $v0
	jal	print_int_and_space

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra