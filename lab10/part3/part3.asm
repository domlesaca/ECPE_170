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
	lw $s0, I	# Load I
	lw $s1, Z	# Load Z

# performing while loop
while1:
	
	bgt $s0, 20, do 	# if(i>20) break;
 	addi $s1, $s1, 1	# Z++
 	addi $s0, $s0, 2	# I += 2
 	j while1		# loop to top of while
 	
do: 	addi $s1, $s1, 1	# Z++
	blt $s1, 100, do	# while(Z<100)
	
while2:	ble $s0, 0, exit	# while(i > 0)
	addi $s1, $s1, -1	# Z--
 	addi $s0, $s0, -1	# I--
 	j while2		# loop to tope of while
	
	
exit:	sw $s1, Z	# Storing $s1 value in at label Z
	sw $s0, I	# Storing $s0 value in at label I
		
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
I:	.word 0		#I = 0
Z:	.word 2		#Z = 2
