# Code for Part 1 of lab 10
# calculates basic arithmetic operations

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text
# The label 'main' represents the starting point
main:
# initializing all arrays
	la $s0, A	# Load base address of A
	la $s1, B	# Load base address of B
	lw $s3, C	# Load C

# performing the for loop
	# for(i=0; i<5; i++)
	li $t0, 0		# i=0
for:	bge $t0, 5, exitfor	# i <5
	mul $t1, $t0, 4		# get proper offset for array
	add $t1, $t1, $s1	# set $t1 to the address of B[i]
	lw $t2, 0($t1)		# Load B[i]
	add $t3, $t2, $s3	# B[i] + C
	mul $t1, $t0, 4		# get proper offset for array
	add $t1, $t1, $s0	# set $t1 to the address of A[i]
	sw $t3, 0($t1)		# A[i] = B[i] + C
	addi $t0, 1		# i++
	j for			# go to top of loop
exitfor:
	addi $t0, -1		# i--
	
# performing while loop 	
while:	blt $t0, 0, exit	# while(i >= 0)
	mul $t1, $t0, 4		# get proper offset for array
	add $t1, $t1, $s0	# set $t1 to the address of A[i]
	lw $t2, 0($t1)		# Load A[i]
	mul $t2, $t2, 2		# A[i] = A[i]*2
	sw $t2, 0($t1)		# place value in A[i]
	addi $t0, -1		# i--
 	j while			# loop to tope of while
	
	
exit:	lw $t1, 0($s0)		# place A[0] in $t1
	sw $t1, 0($s0)	 	# Storing A[0]
	lw $t1, 4($s0)		# place A[1] in $t1
	sw $t1, 4($s0)		# Storing A[1]
	lw $t1, 8($s0)		# place A[2] in $t1
	sw $t1, 8($s0)		# Storing A[2]
	lw $t1, 16($s0)		# place A[3] in $t1
	sw $t1, 16($s0)		# Storing A[3]
	lw $t1, 32($s0)		# place A[4] in $t1
	sw $t1, 32($s0)		# Storing A[4]
	lw $t1, 0($s1)		# place B[0] in $t1
	sw $t1, 0($s1) 		# Storing B[0]
	lw $t1, 4($s1)		# place B[1] in $t1
	sw $t1, 4($s1)		# Storing B[1]
	lw $t1, 8($s1)		# place B[2] in $t1
	sw $t1, 8($s1)		# Storing B[2]
	lw $t1, 16($s1)		# place B[3] in $t1
	sw $t1, 16($s1)		# Storing B[3]
	lw $t1, 32($s1)		# place B[4] in $t1
	sw $t1, 32($s1)		# Storing B[4]
		
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
A:	.word 0:5			# A[5]
B:	.word 1, 2, 3, 4, 5		# B[5] = {1, 2, 3, 4, 5}
C:	.word 12			# C = 12
