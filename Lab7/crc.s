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
	jr	$ra
