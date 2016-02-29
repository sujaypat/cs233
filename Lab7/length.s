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
	jr	$ra
