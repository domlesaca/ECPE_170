# Code for Part 1 of lab 10
# calculates basic arithmetic operations

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text
# The label 'main' represents the starting point
main:
# initializing all values
	lw $t0, A	# Load A
	lw $t1, B	# Load B
	lw $t2, C	# Load C
	lw $s1, Z	# Load Z

# performing if statement
	bgt $t0, $t1, if 	# A > B ||
 	blt $t2, 5, if		# C < 5
 	
 	ble $t0, $t1, elseif	# A =< B ||
 	addi $t3, $t2, 1	# C+1
 	bne $t3, 7, elseif	# (C+1) != 7
 	
else: 	li $s1, 3	# Z = 3
	j switch	# goto switch statement
	
elseif:	li $s1, 2	# Z = 2
	j switch	# goto switch statement
	
if:	li $s1, 1	# Z = 1

# performing the switch statement
switch:	beq $s1, 1, case1	# Z == 1
	beq $s1, 2, case2	# Z == 2
	beq $s1, 3, case3	# Z == 3
	lui $s1, 0		# Z = 0
	j exit			# goto exit

case1:	li $s1, -1		# Z = -1
case2:	addi $s1, $s1, 2 	# Z -= -2
case3:	addi $s1, $s1, 3	# Z -= -3
	
	
exit:	sw $t0, A	# Storing $t0 value in at label A
	sw $t1, B	# Storing $t1 value in at label B
	sw $t2, C	# Storing $t2 value in at label C
	sw $s1, Z	# Storing $s1 value in at label Z
		
	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
A:	.word 10	#A = 10
B:	.word 15	#B = 15
C:	.word 6		#C = 6
Z:	.word 0		#Z = 0
