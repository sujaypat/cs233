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
	move	$t0, $a0		# store dividend in memory
	move	$t1, $a1		# store divisor in memory


	move 	$a0, $a1		# copy divisor to argument0
	jal		length			# jump to length
	move 	$t2, $v0		# copy result to divisor_length
	# jr		$ra				# jump back
	sub		$t3, $t2, 1		# find divisor_length - 1
	sll		$t4, $t0, $t3	# shift dividend left by divisor_length - 1 store in remainder


	move 	$a0, $t4		# copy remainder to argument0
	jal		length			# jump to length
	move 	$t5, $v0		# copy result to remainder_length
	# jr		$ra				# jump back


forloopbody:
	blt		$t5, $t2, end	# i < divisor_length
	sub		$t6, $t5, 1		# remainder_length - 1 (actually i)
	srl		$t7, $t4, $t6	# calc msb
	beq		$t7, 0, end		# msb != 0
	sub		$t8, $t6, $t2	# i - divisor_length
	sll		$t1, $t1, $t8	# shift divisor left by (i - divisor_length)
	xor		$t4, $t4, $t1	# assign remainder to xor'd value
	sub		$t5, $t5, 1		# remainder_length--



end:
	sll		$t0, $t0, $t3
	xor		$t9, $t4, $t0
	move 	$v0, $t9
	# jr		$ra
