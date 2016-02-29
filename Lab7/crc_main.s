.data

# Strings for printing purposes
crc_encoding_0x9a_0xd_str: .asciiz "crc_encoding(0x9a, 0xd) is "
crc_encoding_0x434_0x11_str: .asciiz "crc_encoding(0x434, 0x11) is "

.text
MAIN_STK_SPC = 4
main:
	sub	$sp, $sp, MAIN_STK_SPC
	sw	$ra, 0($sp)

	la	$a0, crc_encoding_0x9a_0xd_str
	jal	print_string
	li	$a0, 0x9a
	li	$a1, 0xd
	jal	crc_encoding
	move	$a0, $v0
	jal	print_int_hex_and_space
	jal	print_newline

	la	$a0, crc_encoding_0x434_0x11_str
	jal	print_string
	li	$a0, 0x434
	li	$a1, 0x11
	jal	crc_encoding
	move	$a0, $v0
	jal	print_int_hex_and_space
	jal	print_newline

	lw	$ra, 0($sp)
	add	$sp, $sp, MAIN_STK_SPC
	jr	$ra
