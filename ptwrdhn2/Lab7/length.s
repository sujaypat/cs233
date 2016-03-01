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
	# Your code goes here :)
	li		$t1, 0		# num_bits
	move	$t2, $a0	# argument

forloop:
	ble		$t2, 0, endfor
	bge		$t1, 32, endfor
	srl		$t2, $t2, 1
	add		$t1, $t1, 1
	j		forloop


endfor:
	move 	$v0, $t1

	jr	$ra
