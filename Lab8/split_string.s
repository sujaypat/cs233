.text
## int
## split_string(char **solution, char *str, const dictionary *dict) {
##     *solution = NULL;
##     char *ptr = str;
##     if (*ptr == 0) {
##         return 1;
##     }
##     for (; *ptr != 0; ptr++) {
##         char *prefix = sub_str(str, ptr + 1 - str);
##         if (in_dict(prefix, dict->words, dict->size)) {
##             if (split_string(solution + 1, ptr + 1, dict)) {
##                 // if the prefix is in dictionary and
##                 // if the rest of the string is also "splittable"
##                 // insert the prefix into solution
##                 *solution = prefix;
##                 return 1;
##             }
##         }
##     }
##     return 0;
## }

.globl split_string
split_string:
	# Your code goes here :)
	sub		$sp, $sp, 28	# sub sp
	sw		$ra, 0($sp)		# store ra in memory
	sw		$a0, 4($sp)		# store **solution in memory
	sw		$a1, 8($sp)		# store *str in memory
	sw		$a2, 12($sp)	# store *dict

	sw		$0, 0($a0)		# *solution = NULL
	move 	$t0, $a1		# *ptr = str
	sw		$t0, 16($sp)	# store *ptr in memory

	lbu		$t1, 0($t0)		# dereference *ptr
	sb		$t1, 20($sp)	# store ptr value in memory

	beq		$t1, $0, return1# if *ptr == 0 return 1

forloop:
	beq		$t1, $0, return0# if *ptr == 0 break

	move 	$a0, $a1		# load str into arg0
	add		$t0, $t0, 1		# ptr + 1
	sub		$t0, $t0, $a0	# ptr + 1 - str
	move 	$a1, $t0		# move prt + 1 - str to arg1
	jal		sub_str			# sub_str(str, ptr + 1 - str)
	move 	$t2, $v0		# save prefix to register
	sw		$t2, 24($sp)	# store prefix in memory

	move 	$a0, $t2		# copy prefix to arg0
	lw		$t1, 12($sp)	# load dict from memory
	lw		$a2, 0($t1)		# load dict->size into arg2
	add		$a1, $t1, 4		# load dict->words into arg1
	jal		in_dict			# in_dict(prefix, dict->words, dict->size)
	beq		$v0, $0, continue# if result is 0 then continue loop

	lw		$a0, 4($sp)		# load solution from memory
	add		$a0, $a0, 4		# solution + 1 into arg0
	lw		$a1, 16($sp)	# load ptr
	add		$a1, $a1, 1		# ptr + 1 into arg1
	lw		$a2, 12($sp)	# load dict into arg2
	jal		split_string	# recursive call split_string(solution + 1, ptr + 1, dict)
	beq		$v0, $0, continue# if result is 0 then continue loop

	lw		$t3, 4($sp)		# *solution
	lw		$t2, 24($sp)	# load prefix from memory
	sw 		$t2, 0($t3)		# *solution = prefix

	j		return1			# jump to return0

continue:
	lw		$t0, 16($sp)	# load ptr from memory
	add		$t0, $t0, 1		# ptr++
	sw		$t0, 16($sp)	# store ptr back into memory
	lw		$a0, 4($sp)		# load **solution from memory
	lw		$a1, 8($sp)		# load *str from memory
	lw		$a2, 12($sp)	# load *dict
	lbu		$t1, 0($t0)		# load *ptr

	j 		forloop			# loop

return1:
	li		$v0, 1			# load 1 into return value
	j		end				# jump to end

return0:
	li		$v0, 0			# load 0 into return value

end:
	lw	$ra, 0($sp)			# load ra from memory
	lw	$a2, 12($sp)		# a2 is const

	add	$sp, $sp, 28		# add to sp

	jr	$ra
