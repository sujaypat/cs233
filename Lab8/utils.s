.data
# Stores the address for the next node to allocate
new_str_address: .word str_memory
# Don't put anything below this just in case they malloc more than 4096
str_memory: .space 4096

.text
# Allocates "memory" for new chars using the space in str_memory.
# Arguments: $a0: bytes of memory to be malloc'ed
# Returns: address to new chars
.globl malloc
malloc:
	lw	$v0, new_str_address
	add	$t0, $v0, $a0
	sw	$t0, new_str_address
	jr	$ra

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
	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)		# char *str
	sw	$s1, 8($sp)		# char **dict
	sw	$s2, 12($sp)		# int dict_size
	sw	$s7, 16($sp)		# int i

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s7, $0			# i = 0

id_for:
	bge	$s7, $s2, id_done 	# i < dict_size
	mul	$t0, $s7, 4
	add	$t0, $t0, $s1		# $t0 = &dict[i]
	move	$a0, $s0		# str
	lw	$a1, 0($t0)		# dict[i]
	jal	str_cmp			# str_cmp(str, dict[i])
	beq	$v0, $0, id_ret_1	# if (!str_cmp(str, dict[i]))
	add	$s7, $s7, 1		# i++
	j	id_for

id_ret_1:
	li	$v0, 1			# return 1
	j	id_ret

id_done:
	move	$v0, $0			# return 0
id_ret:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)		# char *str
	lw	$s1, 8($sp)		# char **dict
	lw	$s2, 12($sp)		# int dict_size
	lw	$s7, 16($sp)		# int i
	add	$sp, $sp, 20
	jr	$ra