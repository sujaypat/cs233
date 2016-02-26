# add your own tests for the full machine here!
# feel free to take inspiration from all.s and/or lwbr2.s

.data
# your test data goes here
a: .word 0 1 2 4 8 16

.text
main:
	la $4, a
	lw $5, 0($4)
	lw $6, 4($4)
	
