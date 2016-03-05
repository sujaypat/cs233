.text

## #define UNSIGNED_SIZE 32
##
## int
## length(unsigned binary) {
##     int num_bits = 0;
##     for (; binary > 0 && num_bits < UNSIGNED_SIZE; num_bits++) {
##         binary = binary >> 1;
##     }
##     return num_bits;
## }

.globl length
length:
	li	$v0, 0			# int num_buts = 0

l_for:
	bleu	$a0, $0, l_done		# binary > 0
	bge	$v0, 32, l_done		# num_bits < UNSIGNED_SIZE
	srl	$a0, $a0, 1		# binary = binary >> 1
	add	$v0, $v0, 1		# num_bits++
	j	l_for

l_done:
	jr	$ra			# return num_bits
