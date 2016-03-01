.text

## int
## str_cmp(const char *src, const char *tgt) {
##     for (; *src && *tgt; src++, tgt++) {
##         if (*src != *tgt) {
##             break;
##         }
##     }
##     // false is 0, true is anything else
##     return *src != *tgt;
## }

.globl str_cmp
str_cmp:
	# Your code goes here :)
	move 	$t0, $a0 # copy of src
	move 	$t1, $a1 # copy of tgt

forloop:
	lbu		$s0, 0($t0)		#
	lbu		$s1, 0($t1)		#
	and		$t2, $s0, $s1 	# and statement
	beq		$t2, 0, end		# check that *src && *tgt is not 0
	bne		$s0, $s1, end	# compare *src and *tgt
	add		$t0, $t0, 1		# src++
	add		$t1, $t1, 1		# tgt++
	j		forloop			# jump to beginning of loop

end:
	bne		$s0, $s1, endfalse	# check if src = tgt
	li 		$v0, 0				# return false
	j 		quit

endfalse:
	li		$v0, 1				# return true

quit:

	jr	$ra
