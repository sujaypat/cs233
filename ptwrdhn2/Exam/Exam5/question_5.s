# run with QtSpim -file main.s question_5.s

# struct node_t {
#     node_t *left;
#     node_t *right;
#     int data;
# };
# 
# void tweak_all(node_t *root, int zonk, int frood) {
#     if (root == NULL) {
#         return;
#     }
# 
#     if (root->data != zonk) {
#         root->data = tweak(root->data, frood);
#     }
# 
#     tweak_all(root->left, frood, zonk);
#     tweak_all(root->right, frood, zonk);
# }
.globl tweak_all
tweak_all:
	sub	$sp, $sp, 20
	sw	$ra, 0($sp)
	sw 	$s0, 4($sp)
	sw	$s1, 8($sp)
	sw	$s2, 12($sp)
	sw	$s3, 16($sp)
	
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2

	
	beq	$s0, $0, end

	lw	$t0, 8($s0)
	beq	$t0, $s1, cont
	move	$a0, $t0
	move	$a1, $s2
	jal	tweak
	move	$s3, $v0
	sw	$s3, 8($s0)
	
cont:	
	lw	$a0, 0($s0)
	move	$a1, $s2
	move	$a2, $s1
	jal	tweak_all
	
	lw	$a0, 4($s0)
	move	$a1, $s2
	move	$a2, $s1
	jal	tweak_all

end:
	lw	$ra, 0($sp)
	lw 	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	add	$sp, $sp, 20
	jr	$ra
