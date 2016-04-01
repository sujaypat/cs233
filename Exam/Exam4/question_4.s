# run with QtSpim -file main.s question_4.s

# void array_swap_char(char *A, int a_length, char *B, int b_length) {
#     int length = a_length;
#     if (b_length < a_length) {
#         length = b_length;
#     }
# 
#     for (int i = 0; i < length; i++) {
#         char temp = A[i];
#         A[i] = B[i];
#         B[i] = temp;
#     }
# }
.globl array_swap_char
array_swap_char:

	move $t0, $a1
	bge $a3, $a1, continue
	move $t0, $a3
continue:
	li $t1, 0
forloop:
	bge $t1, $t0, end
	add $t2, $a0, $t1 # *A + i
	add $t4, $a2, $t1 # *B + i
	lbu $t3, 0($t2) # A[i]
	lbu $t5, 0($t4) # B[i]
	sb  $t3, 0($t4)
	sb  $t5, 0($t2)


	add $t1, $t1, 1
	j forloop
end:
	jr $ra
