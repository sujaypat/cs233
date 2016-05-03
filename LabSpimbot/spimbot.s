# syscall constants
PRINT_STRING = 4
PRINT_CHAR   = 11
PRINT_INT	= 1

# debug constants
PRINT_INT_ADDR   = 0xffff0080
PRINT_FLOAT_ADDR = 0xffff0084
PRINT_HEX_ADDR   = 0xffff0088

# spimbot constants
VELOCITY   	= 0xffff0010
ANGLE      	= 0xffff0014
ANGLE_CONTROL  = 0xffff0018
BOT_X      	= 0xffff0020
BOT_Y      	= 0xffff0024
OTHER_BOT_X	= 0xffff00a0
OTHER_BOT_Y	= 0xffff00a4
TIMER      	= 0xffff001c
SCORES_REQUEST = 0xffff1018

PLANT_SCAN        	= 0xffff0050
CLOUD_SCAN        	= 0xffff0054
CLOUD_STATUS_INFO 	= 0xffff00c0
GET_WATER         	= 0xffff00c8
WATER_VALVE       	= 0xffff00c4
REQUEST_PUZZLE    	= 0xffff00d0
REQUEST_PUZZLE_STRING = 0xffff00dc
SUBMIT_SOLUTION   	= 0xffff00d4

# interrupts constants
BONK_MASK  = 0x1000
BONK_ACK   = 0xffff0060
TIMER_MASK = 0x8000
TIMER_ACK  = 0xffff006c

CLOUD_CHANGE_STATUS_ACK  	= 0xffff0064
CLOUD_CHANGE_STATUS_INT_MASK = 0x2000
OUT_OF_WATER_ACK         	= 0xffff0068
OUT_OF_WATER_INT_MASK    	= 0x4000
PLANT_FULLY_WATERED_ACK  	= 0xffff0058
PLANT_FULLY_WATERED_INT_MASK = 0x400
REQUEST_PUZZLE_ACK       	= 0xffff00d8
REQUEST_PUZZLE_INT_MASK  	= 0x800

.data
.align 2
puzzle_data: .space 13528
# data things go here
.align 2
plant_data: .space 88
.align 2
cloud_data: .space 120

.align 0
puzzle_string: .space 129
.align 2
soln_data: .space 516
one: .word 1

new_str_address: .word str_memory
	# Don't put anything below this just in case they malloc more than 4096

str_memory: .space 4096




.text
main:
	li	$s7, 4
	li	$s8, 8
	li		$t4, CLOUD_CHANGE_STATUS_INT_MASK		# timer interrupt enable bit
	or		$t4, $t4, 1		# global interrupt enable
	or		$t4, $t4, OUT_OF_WATER_INT_MASK		# timer interrupt enable bit
	or		$t4, $t4, PLANT_FULLY_WATERED_INT_MASK		# timer interrupt enable bit
#	or		$t4, $t4, REQUEST_PUZZLE_INT_MASK		# timer interrupt enable bit
	or		$t4, $t4, BONK_MASK
	mtc0	$t4, $12		# set interrupt mask (Status register)
main_loop:
	# go wild
	# the world is your oyster :)

	li		$t0, 10
	sw  		$t0, VELOCITY

	la		$t0, cloud_data
	sw		$t0, CLOUD_SCAN

	la		$t0, plant_data
	sw		$t0, PLANT_SCAN

	lw		$s0, BOT_X		# spimbot x loc
	lw		$s1, BOT_Y		# spimbot y loc


	la		$a0, cloud_data
	jal		closest_cloud

	add	$v1, $v1, 18
	li	$t0, 1
	blt	$s0, 150, store_angle
	li	$t0, -1
store_angle:
	sw	$t0, ANGLE
	li	$t2, 0
	li	$t3, 0
turn:
	add	$t2, $t2, 1
	bne	$t2, 75, turn
	li	$t2, 0
	add	$t3, $t3, 1
	sw	$0, ANGLE_CONTROL
	bne	$t3, 180, turn
move_down:
	lw	$t0, BOT_Y
	blt	$t0, $v1, move_down

	move 	$a0, $v0
	move 	$a1, $v1
	jal 	change_direction
	li	$t0, 10
	sw	$t0, VELOCITY
	li	$t0, -90
	sw	$t0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL
loop:
	add	$t9, $t9, 1
	beq	$t9, 7000, leave_loop
	lw	$s1, BOT_Y
	blt	$s1, 20, leave_loop
	j	loop
leave_loop:
	sw	$0, WATER_VALVE
	j	main_loop



# @param: $a0 = destination.x, $a1 = destination.y
# points spimbot in the direction of x,y
change_direction:
	lw	$s0, BOT_X		# spimbot x loc
	lw	$s1, BOT_Y		# spimbot y loc
	move	$s2, $a0
	move	$s3, $a1
	sw	$ra, 0($sp)
	sub	$a0, $a0, $s0
	sub	$a1, $a1, $s1
	jal	sb_arctan
	sw	$v0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL
dir_loop:
	lw	$s0, BOT_X		# spimbot x loc
	lw	$s1, BOT_Y		# spimbot y loc
	li	$t0, 10
	sw	$t0, VELOCITY
	sub	$t0, $s0, $s2
	sub	$t1, $s1, $s3
	bgt	$t0, 1, dir_loop
	#bgt	$t1, 1, dir_loop
	blt	$t0, -1, dir_loop
	#blt	$t1, -1, dir_loop

	lw	$ra, 0($sp)
	jr	$ra





closest_cloud:		#address takes array of cloud data returns x, y pos of nearest cloud
	add	$a0, $a0, $s8
	lw	$v0, 0($a0)
	lw	$v1, 4($a0)
	add	$s8, $s8, 12
	blt	$s8, 35, cloud_end
	li	$s8, 8
cloud_end:
	jr	$ra




.data
three:	.float	3.0
five:	.float	5.0
PI:	.float	3.141592
F180:	.float  180.0

.text

# -----------------------------------------------------------------------
# sb_arctan - computes the arctangent of y / x
# $a0 - x
# $a1 - y
# returns the arctangent
# -----------------------------------------------------------------------

sb_arctan:
	li	$v0, 0		# angle = 0;

	abs	$t0, $a0	# get absolute values
	abs	$t1, $a1
	ble	$t1, $t0, no_TURN_90

	## if (abs(y) > abs(x)) { rotate 90 degrees }
	move	$t0, $a1	# int temp = y;
	neg	$a1, $a0	# y = -x;
	move	$a0, $t0	# x = temp;
	li	$v0, 90		# angle = 90;

no_TURN_90:
	bgez	$a0, pos_x 	# skip if (x >= 0)

	## if (x < 0)
	add	$v0, $v0, 180	# angle += 180;

pos_x:
	mtc1	$a0, $f0
	mtc1	$a1, $f1
	cvt.s.w $f0, $f0	# convert from ints to floats
	cvt.s.w $f1, $f1

	div.s	$f0, $f1, $f0	# float v = (float) y / (float) x;

	mul.s	$f1, $f0, $f0	# v^^2
	mul.s	$f2, $f1, $f0	# v^^3
	l.s	$f3, three	# load 5.0
	div.s 	$f3, $f2, $f3	# v^^3/3
	sub.s	$f6, $f0, $f3	# v - v^^3/3

	mul.s	$f4, $f1, $f2	# v^^5
	l.s	$f5, five	# load 3.0
	div.s 	$f5, $f4, $f5	# v^^5/5
	add.s	$f6, $f6, $f5	# value = v - v^^3/3 + v^^5/5

	l.s	$f8, PI		# load PI
	div.s	$f6, $f6, $f8	# value / PI
	l.s	$f7, F180	# load 180.0
	mul.s	$f6, $f6, $f7	# 180.0 * value / PI

	cvt.w.s $f6, $f6	# convert "delta" back to integer
	mfc1	$t0, $f6
	add	$v0, $v0, $t0	# angle += delta

	jr 	$ra




###
###
#interrupts#
###
###

.kdata				# interrupt handler data (separated just for readability)
chunkIH:	.space 8	# space for two registers
non_intrpt_str:	.asciiz "Non-interrupt exception\n"
unhandled_str:	.asciiz "Unhandled interrupt type\n"


.ktext 0x80000180
interrupt_handler:
.set noat
	move	$k1, $at		# Save $at
.set at
	la	$k0, chunkIH
	sw	$a0, 0($k0)		# Get some free registers
	sw	$a1, 4($k0)		# by storing them to a global variable

interrupt_dispatch:			# Interrupt:
	mfc0	$k0, $13		# Get Cause register, again
	beq	$k0, 0, done		# handled all outstanding interrupts

	and	$a0, $k0, CLOUD_CHANGE_STATUS_INT_MASK	# is there a cloud status interrupt?
	bne	$a0, 0, cloud_interrupt

	and	$a0, $k0, BONK_MASK
	bne	$a0, 0, bonk_interrupt

	and	$a0, $k0, PLANT_FULLY_WATERED_INT_MASK
	bne	$a0, 0, plant_interrupt

	li	$v0, PRINT_STRING	# Unhandled interrupt types
	la	$a0, unhandled_str
	syscall
	j	done

bonk_interrupt:
		sw	$a1, BONK_ACK
	lw	$s0, BOT_X
	lw	$s1, BOT_Y
	bgt	$s1, 150, lowerhalf
	bgt	$s0, 150, topright
	j	topleft
lowerhalf:
	bgt	$s0, 150, lowerright
	j	lowerleft
topleft:
	li	$t0, 45
	j	bonk_end
topright:
	li	$t0, 135
	j	bonk_end
lowerleft:
	li	$t0, -10
	j	bonk_end
lowerright:
	li	$t0, 190
bonk_end:
	sw	$t0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL
	li	$t0, 10
	sw	$t0, VELOCITY
	j	done


plant_interrupt:
	sw	$0, WATER_VALVE
	j	done

cloud_interrupt:
	sw	$a1, CLOUD_CHANGE_STATUS_ACK
	lw	$t0, ANGLE
	bne	$t0, 270, done
	la	$t1, plant_data
	add	$t1, $t1, $s7
	lw	$t1, 0($t1)
go:
	lw	$s0, BOT_X
	beq	$s0, $t1, stop
	blt	$s0, $t1, right
	j	left
stop:
	add	$s7, $s7, 8
	blt	$s7, 38, up
	li	$s7, 4
up:
	li	$t0, 269
	sw	$t0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL
	sw	$t0, WATER_VALVE
	li	$t9, 0
	j	done
right:
	sw	$0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL
	j 	go
left:
	li	$t0, 180
	sw	$t0, ANGLE
	li	$t0, 1
	sw	$t0, ANGLE_CONTROL
	j	go



puzzle_interrupt:
	sub 		$sp, $sp, 28
sw		$ra, 0($sp)
	sw		$s0, 4($sp)
sw		$s1, 8($sp)
sw		$s2, 12($sp)
	sw		$s3, 16($sp)
	sw		$s7, 20($sp)
	sw		$s8, 24($sp)


	sw		$a1, CLOUD_CHANGE_STATUS_ACK

	la		$a2, puzzle_string
	sw		$a2, REQUEST_PUZZLE_STRING

	la		$a0, soln_data
	la		$a1, puzzle_string
	la		$a2, puzzle_data
		jal split_string
	la		$a0, soln_data
	sw		$a0, SUBMIT_SOLUTION
	lw 		$ra, 0($sp)
lw		$ra, 0($sp)
	lw		$s0, 4($sp)
lw		$s1, 8($sp)
lw		$s2, 12($sp)
	lw		$s3, 16($sp)
	lw		$s7, 20($sp)
	lw		$s8, 24($sp)
	add		$sp, $sp, 28
	j done

	#Beginning of code copied from SVN to solve puzzle
	#Split String takes: char **solution, char *str, const dictionary *dict


malloc:
	lw	$v0, new_str_address
	add	$t0, $v0, $a0
	sw	$t0, new_str_address
	jr	$ra

split_string:
	sw	$0, 0($a0)
	lb	$t0, 0($a1)
	bne	$t0, $0, ss_recurse
	li	$v0, 1
	jr	$ra

ss_recurse:
	sub	$sp, $sp, 24
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)		# char **solution
	sw	$s1, 8($sp)		# char *str
	sw	$s2, 12($sp)		# dictionary *dict
	sw	$s3, 16($sp)		# char *ptr
	sw	$s4, 20($sp)		# char *prefix

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a1

ss_for:
	lb	$t0, 0($s3)	        # *ptr
	beq	$t0, $0, ss_done	# *ptr != 0

	move	$a0, $s1		# str
	add	$a1, $s3, 1		# ptr + 1
	sub	$a1, $a1, $s1		# ptr + 1 - str
	jal	sub_str			# sub_str(str, ptr + 1 - str)
	move	$s4, $v0		# prefix

	move	$a0, $s4		# prefix
	add	$a1, $s2, 4		# dict->words
	lw	$a2, 0($s2)		# dict->size
	jal	in_dict			# in_dict(prefix, dict->words, dict->size)
	beq	$v0, $0, ss_continue

	add	$a0, $s0, 4		# solution + 1
	add	$a1, $s3, 1		# ptr + 1
	move	$a2, $s2		# dict
	jal	split_string		# split_string(solution + 1, ptr + 1, dict)
	beq	$v0, $0, ss_continue

	sw	$s4, 0($s0)		# *solution = prefix
	li	$v0, 1			# return 1
	j	ss_return

ss_continue:
	add	$s3, $s3, 1		# ptr++
	j	ss_for

ss_done:
	li	$v0, 0			# return 0

ss_return:
	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	lw	$s3, 16($sp)
	lw	$s4, 20($sp)
	add	$sp, $sp, 24
	jr	$ra

sub_str:
	sub	$sp, $sp, 12
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
	sw	$s1, 8($sp)

	move	$s0, $a0		# str
	move	$s1, $a1		# n

	add	$a0, $s1, 1		# n + 1
	jal	malloc			# malloc(n + 1)
	li	$t0, 0			# len = 0

sub_str_for:
	bge	$t0, $s1, sub_str_ret	# len >= n
	add	$t1, $s0, $t0		# &str[len]
	lb	$t1, 0($t1)		# str[len]
	beq	$t1, 0, sub_str_ret	# str[len] == '\0'

	add	$t2, $v0, $t0		# &newstr[len]
	sb	$t1, 0($t2)		# newstr[len] = str[len]

	add	$t0, $t0, 1		# len++
	j	sub_str_for

sub_str_ret:
	add	$t2, $v0, $t0		# &newstr[len]
	sb	$0, 0($t2)		# newstr[len] = '\0'

	lw	$ra, 0($sp)
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	add	$sp, $sp, 12
	jr	$ra

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



done:
	la	$k0, chunkIH
	lw	$a0, 0($k0)		# Restore saved registers
	lw	$a1, 4($k0)
.set noat
	move	$at, $k1		# Restore $at
.set at
	eret