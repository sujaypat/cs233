.text

## int
## in_dict(const char *str, const char **dict, const int dict_size) {
##     for (int i = 0; i < dict_size; i++) {
##         // equivalent to if (str_cmp(str, dict[i]) == 0)
##         if (!str_cmp(str, dict[i])) {
##             return 1;
##         }
##     }
##     return 0;
## }

.globl in_dict
in_dict:
	# Your code goes here :)
	sub		$sp, $sp, 24	# set sp back
	sw		$ra, 0($sp)		# store ra in memory
	sw		$a0, 4($sp)		# store *str in memory
	sw		$a1, 8($sp)		# store **dict in memory
	sw		$a2, 12($sp)	# store dict_size in memory

	li 		$t0, 0			# temp i variable

forloop:
	bge		$t0, $a2, end0	# forloop condition
	mul		$t9, $t0, 4		# 4byte align
	add		$t2, $a1, $t9	# add i to array pointer
	lw		$t1, 0($t2)		# get array dict[]
	sw		$t1, 20($sp)	# store dict[]
	sw		$t0, 16($sp)	# save i to memory
	move 	$a1, $t1		# copy dict[i] to a1

	jal		str_cmp			# str_cmp(str, dict[i])

	lw		$t1, 20($sp)	# load dict[]
	lw		$a0, 4($sp)		# load *str from memory
	lw		$a1, 8($sp)		# load **dict from memory
	lw		$a2, 12($sp)	# load dict_size from memory
	lw		$t0, 16($sp)	# load i from memory
	bne		$v0, 0, resumeloop	# if (!str_cmp(str, dict[i]))
	li 		$v0, 1			# set return value to 1
	j		end				# jump to forloop
resumeloop:
	add		$t0, $t0, 1		# i++
	j		forloop			# jump to beginning of loop

end0:
	li		$v0, 0			# set return value to 0

end:
	lw		$t1, 20($sp)	# load dict[]
	lw		$a0, 4($sp)		# load *str from memory
	lw		$a1, 8($sp)		# load **dict from memory
	lw		$a2, 12($sp)	# load dict_size from memory
	lw		$t0, 16($sp)	# load i from memory
	lw		$ra, 0($sp)		# reload ra from memory
	add		$sp, $sp, 24	# add back to sp
	jr		$ra
