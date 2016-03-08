.text

## char *
## sub_str(char *str, size_t n) {
##     char *newstr = (char *)malloc(n + 1);
##     int len = 0;
##     for (len = 0 ; len < n && str[len] != '\0' ; len++) {
##         newstr[len] = str[len];
##     }
##     newstr[len] = '\0';
##     return newstr;
## }

.globl sub_str
sub_str:
	# Your code goes here :)
	sub		$sp, $sp, 12	# subtract sp
	sw		$a0, 0($sp)		# store char* str
	sw		$a1, 4($sp)		# store n
	sw		$ra, 8($sp)		# store ra

	add		$t2, $a1, 1		# n + 1

	move 	$a0, $t2		# copy n - 1 into argument0
	jal		malloc			# call malloc on n - 1
	move 	$t9, $v0		# load result into newstr

	lw		$a0, 0($sp)		# reload char* str after malloc
	lw		$a1, 4($sp)		# reload n after malloc
	li		$t3, 0			# len = 0

forloop:
	bge		$t3, $a1, end	# if len >= n end loop
	add		$t5, $a0, $t3	# offset = counter
	lbu		$t4, 0($t5)		# load str[offset]
	beq		$t4, $0, end	# if str[len] == 0 end loop
	add		$t8, $t9, $t3	# offset = counter
	sb		$t4, 0($t8)		# store str[offset] into newstr[offset]
	add		$t3, $t3, 1		# len++
	j		forloop			# jump to forloop



end:
	add		$a0, $t3, $t9	#  =  +
	sb		$0, 0($a0)		# store null in last entry of array
	move 	$v0, $t9		# store newstr into return reg
	lw		$ra, 8($sp)		# reload ra
	add		$sp, $sp, 12	# put back sp
    jr  	$ra
