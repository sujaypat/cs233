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
	lb	$t0, 0($a0)		# *src
	lb	$t1, 0($a1)		# *tgt
	beq	$t0, $0, sc_done	# *srg != 0
	beq	$t1, $0, sc_done	# *tgt != 0
	bne	$t0, $t1, sc_done	# *src != *tgt
	add	$a0, $a0, 1		# src++
	add	$a1, $a1, 1		# tgt++
	j	str_cmp

sc_done:
	bne	$t0, $t1, sc_true	# *src != *tgt
	move	$v0, $0			# return false
	jr	$ra

sc_true:
	li	$v0, 1			# return true
	jr	$ra
