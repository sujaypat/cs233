.text

## unsigned
## crc_encoding(unsigned dividend, unsigned divisor) {
##     int divisor_length = length(divisor);
##     unsigned remainder = dividend << (divisor_length - 1);
##     int remainder_length = length(remainder);
##     for (int i = remainder_length; i >= divisor_length; i--) {
##         unsigned msb = remainder >> (i - 1);
##         // equivalent to if (msb != 0)
##         if (msb) {
##             remainder = remainder ^ (divisor << (i - divisor_length));
##         }
##     }
##     return (dividend << (divisor_length - 1)) ^ remainder;
## }

.globl crc_encoding
crc_encoding:
	# Your code goes here :)
	sub		$sp, $sp, 24	#  stack pointer subtraction
	sw		$ra, 0($sp)
	sw		$a0, 4($sp)		# store dividend in memory
	sw		$a1, 8($sp)		# store divisor in memory


	move 	$a0, $a1		# copy divisor to argument0
	jal		length			# jump to length
	move 	$t2, $v0		# copy result to divisor_length
	sw		$t2, 12($sp)	# divisor_length to memory


	sub		$t3, $t2, 1		# find divisor_length - 1
	sw		$t3, 16($sp)	#
	lw		$a0, 4($sp)		# load dividend from memory
	sll		$t4, $a0, $t3	# shift dividend left by divisor_length - 1 store in remainder
	sw		$t4, 20($sp)	# store remainder


	move 	$a0, $t4		# copy remainder to argument0
	jal		length			# jump to length
	move 	$t5, $v0		# copy result to remainder_length
	lw		$t2, 12($sp)	# load divisor_length
	lw		$t3, 16($sp)	# load divisor_length - 1
	lw		$t4, 20($sp)	# load remainder
	lw		$a0, 4($sp)		# load dividend from memory
	lw		$a1, 8($sp)		# load divisor from memory


forloopbody:
	blt		$t5, $t2, end	# i < divisor_length
	sub		$t6, $t5, 1		# i - 1
	srl		$t7, $t4, $t6	# msb = remainder >> (i - 1)
	beq		$t7, 0, skip	# msb != 0
	sub		$t8, $t5, $t2	# i - divisor_length
	sll		$t1, $a1, $t8	# (divisor << (i - divisor_length))
	xor		$t4, $t4, $t1	# assign remainder to xor'd value
skip:
	sub		$t5, $t5, 1		# remainder_length--
	j		forloopbody		# jump to beginning of loop



end:
	# lw		$a0, 4($sp)	# load dividend from memory
	# lw		$a1, 8($sp)	# load divisor from memory
	sll		$a0, $a0, $t3	# (dividend << (divisor_length - 1))
	xor		$t4, $t4, $a0	#  ^ remainder
	move 	$v0, $t4		# copy remainder to result
	lw		$ra, 0($sp)		#
	add		$sp, $sp, 24	#  =  -
	jr		$ra
