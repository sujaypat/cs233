# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr2.s

.data
# your test data goes here
a: .word 0 1 2 4 8 16
array:	.word	1	255	1024

.text
# main:
# 	la	$4, a
# 	lw	$5, 0($4)
# 	lw	$6, 4($4)
# 	lui $29, 14687
main:   addi	$10, $0, 255		# $10 = 255
	la	$2, array   		# $2  = 0x10010000
	lw	$3, 0($2)		# $3  = 1
	lw	$4, 4($2)		# $4  = 255
	beq	$4, $10, equal		# branch taken

	addi	$11, $0, 1		# skipped
	j	end	    		# skipped

equal:	addi	$12, $0, 2		# $12 = 2
	bne	$4, $10, end		# branch not taken
	add	$14, $3, $4		# $14 = 256

end:	addi	$13, $0, 3		# $13 = 3
