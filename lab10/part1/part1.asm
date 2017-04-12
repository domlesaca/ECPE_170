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
A:	li $t0, 15	# Load immediate value of 15
B:	li $t1, 10	# Load immediate value of 10
C:	li $t2, 7	# Load immediate value of 7
D:	li $t3, 2	# Load immediate value of 2
E:	li $t4, 18	# Load immediate value of 18
F:	li $t5, -3	# Load immediate value of -3
	lw $s1, Z	# Load word stored at label vlaue

# performing operations
	add $t6, $t1, $t0 	# Setting $t6 = A + B
	sub $t7, $t2, $t3 	# Setting $t7 = C - D
	add $t8, $t4, $t5 	# Setting $t8 = E + F
	sub $t9, $t0, $t2 	# Setting $t9 = A - C
	add $s1, $t6, $t7	# Setting $s1 = (A+B)+(C-D)
	add $s1, $s1, $t8	# Setting $s1 = (A+B)+(C-D)+(E+F)
	sub $s1, $s1, $t9	# Setting $s1 = (A+B)+(C-D)+(E+F)-(A-C)
	
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
Z:	.word 0
