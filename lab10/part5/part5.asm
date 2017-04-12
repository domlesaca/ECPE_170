# Code for Part 1 of lab 10
# calculates basic arithmetic operations

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text
# The label 'main' represents the starting point
main:
# initializing variables
	la $s0, string		# Load base address of string
	la $s1, result		# Load result pointer
	li $s2, 0		# int i = 0

# Scanning input from user
	#scanf("%255s", string)
	li $v0, 8		# read_string
	la $a0, string		# load string as the string buffer
	li $a1, 255 		# Load 255 as length of buffer
	syscall			# call the scanf

	la $s0, string		# Load base address of string	
	
# Performing while loop
while:	#mul $t0, $s2, 1		# get proper offset for array
	#add $t0, $t0, $s0	# set $t0 to th address string[i]
	lb $t1, 0($s0)		# Load string[i]
	beq $t1, 0, ifstate	# while(string[i] != '\0')
	beq $t1, 101, isE	# if(string[i] == 'e')	
	addi $s2, $s2, 1	# i++
	la $s0, 1($s0)		# increment $s0 by 1 address
	j while			# loop to top of the while
	
isE:	
	la $s1, 0($s0)		#result = &string[i]
	sw $s1, result		# store result in memory
	j if			# go staight to the if

	
ifstate:
	# printf("No match found\n")
	li $v0, 4		# print_string
	la $a0, fail		# set address to fail string
	syscall			# call printf
	j exit			# skip the if code below

if:	# printf("First match at address ")
	li $v0, 4		# print_string
	la $a0, matchAd		# set address to matchAd string
	syscall			# call printf			
	# printf("%d", result)
	li $v0, 1		# print_int
	la $a0, 0($s0)		# set address to result address
	syscall
	# print("\n")
	li $v0, 4		#print_string
	la $a0, newline		# set address to newline char
	syscall
	# print("The matching character is ")
	li $v0, 4		#print_string
	la $a0, matchChar	# set address to matchChar string
	syscall	
	# print("%c", *result)
	li $v0, 11		# call printf	
	lb $a0, 0($s0)		# set to 
	syscall
	
exit:	
	la $t0, 0($s0)
	sw $t0, result	# save result to memory
		
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
string:		.byte 0:256		# char string[256]
result:		.word 0			# char *result = NULL
matchAd:	.asciiz "First match at address " #string for success print
matchChar:	.asciiz "The matching character is " #2nd string for success
newline:	.asciiz "\n"		# new line char
fail:		.asciiz "No match found\n" # string is match not found
