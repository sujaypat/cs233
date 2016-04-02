# syscall constants
PRINT_STRING	= 4
PRINT_CHAR	= 11
PRINT_INT	= 1

# memory-mapped I/O
VELOCITY	= 0xffff0010
ANGLE		= 0xffff0014
ANGLE_CONTROL	= 0xffff0018

BOT_X		= 0xffff0020
BOT_Y		= 0xffff0024

TIMER		= 0xffff001c

PLANT_SCAN	= 0xffff0050

CLOUD_SCAN		= 0xffff0054
CLOUD_STATUS_INFO	= 0xffff00c0

GET_WATER	= 0xffff00c8
WATER_VALVE	= 0xffff00c4

PRINT_INT_ADDR		= 0xffff0080
PRINT_FLOAT_ADDR	= 0xffff0084
PRINT_HEX_ADDR		= 0xffff0088

# interrupt constants
BONK_MASK	= 0x1000
BONK_ACK	= 0xffff0060

TIMER_MASK	= 0x8000
TIMER_ACK	= 0xffff006c

CLOUD_CHANGE_STATUS_ACK		= 0xffff0064
CLOUD_CHANGE_STATUS_INT_MASK	= 0x2000

OUT_OF_WATER_ACK	= 0xffff0068
OUT_OF_WATER_INT_MASK	= 0x4000


.data
# put your data things here
.align 2
cloud_data: .space 40
.align 2
plant_data: .space 88

.text
main:
	# put your code here :)

	# enable interrupts
	li	$t4, CLOUD_CHANGE_STATUS_INT_MASK		# timer interrupt enable bit
	or	$t4, $t4, 1		# global interrupt enable
	mtc0	$t4, $12		# set interrupt mask (Status register)

	la	$t0, cloud_data	#
	sw	$t0, CLOUD_SCAN	#

	lw	$t1, BOT_X		# spimbot x loc
	lw	$t2, BOT_Y		# spimbot y loc

	lw	$t3, 8($t0)		# cloud x loc
	lw	$t4, 12($t0)	# cloud y loc

	bgt	$t2, $t4, continue

init:
	li	$t5, 90		#  =
	sw	$t5, ANGLE		#
	li	$t6, 1		#  =
	sw	$t6, ANGLE_CONTROL		#

continue:





get_below_cloud:
	lw	$t1, BOT_X		# spimbot x loc
	lw	$t3, 8($t0)		# cloud x loc

	beq	$t1, $t3, go_up
	blt $t3, $t1, go_left
	li	$t5, 0		#  =
	sw	$t5, ANGLE		#
	li	$t6, 1		#  =
	sw	$t6, ANGLE_CONTROL		#
	beq	$t1, $t3, go_up	# if  ==  then
	j 	main

go_left:
	lw	$t1, BOT_X		# spimbot x loc
	lw	$t3, 8($t0)		# cloud x loc
	beq	$t1, $t3, go_up
	li	$t5, 180		#  =
	sw	$t5, ANGLE		#
	li	$t6, 1		#  =
	sw	$t6, ANGLE_CONTROL		#
	beq	$t1, $t3, go_up	#
	j 	main

go_up:
	lw	$t2, BOT_Y		# spimbot y loc
	lw	$t4, 12($t0)	# cloud y loc

	li	$t5, 270		#  =
	sw	$t5, ANGLE		#
	li	$t6, 1		#  =
	sw	$t6, ANGLE_CONTROL		#
	# note that we infinite loop to avoid stopping the simulation early
	j	main





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

		mfc0	$k0, $13		# Get Cause register
		srl	$a0, $k0, 2
		and	$a0, $a0, 0xf		# ExcCode field
		bne	$a0, 0, non_intrpt

interrupt_dispatch:			# Interrupt:
		mfc0	$k0, $13		# Get Cause register, again
		beq	$k0, 0, done		# handled all outstanding interrupts

		and	$a0, $k0, CLOUD_CHANGE_STATUS_INT_MASK	# is there a bonk interrupt?
		bne	$a0, 0, cloud_interrupt


		# add dispatch for other interrupt types here.

		li	$v0, PRINT_STRING	# Unhandled interrupt types
		la	$a0, unhandled_str
		syscall
		j	done

cloud_interrupt:
		sw	$a1, CLOUD_CHANGE_STATUS_ACK		# acknowledge interrupt

		lw	$t5, ANGLE		#
		li	$t7, 90		#  =
		# li	$t6, 1		#  =
		# sw	$t6, ANGLE_CONTROL		#

		beq	$t5, $t7, interrupt_dispatch	# if  ==  then
		sw	$zero, VELOCITY		# ???
		sw	$t6, WATER_VALVE
		# sw		$t1, 0($s1)		#


		part1:
			# put your code here :)
			la		$t0, plant_data	#
			sw		$t0, PLANT_SCAN	#

			lw		$t1, 4($t0)		# load plant 0 x loc
			lw		$t2, BOT_X		# load spimbot x loc


		angle_setting:
			sub 	$t3, $t2, $t1	# $t3 will be 1 if bot is right of plant0

			li		$t9, 1			#
			sw		$t9, ANGLE_CONTROL	# set angle to absolute

			bne		$t3, 0, water_b____es	# if  ==  then
			sw		$t9, WATER_VALVE#  =

		water_b____es:

			bgt		$t3, 0, ebola	#
			li		$t8, 0			#
			sw		$t8, ANGLE		#
			j		velocity_setting# jump to velocity_setting

		ebola:
			li		$t8, 180		#
			sw		$t8, ANGLE		#

		velocity_setting:
			li		$t7, 10			#  =

			sw		$t7, VELOCITY	#

		end:

			# note that we infinite loop to avoid stopping the simulation early
			j	part1



		j	interrupt_dispatch	# see if other interrupts are waiting

non_intrpt:				# was some non-interrupt
		li	$v0, PRINT_STRING
		la	$a0, non_intrpt_str
		syscall				# print out an error message
		# fall through to done

done:
		la	$k0, chunkIH
		lw	$a0, 0($k0)		# Restore saved registers
		lw	$a1, 4($k0)
.set noat
		move	$at, $k1		# Restore $at
.set at
		eret
