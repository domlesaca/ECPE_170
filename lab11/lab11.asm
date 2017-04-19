# Code for Part 1 of lab 10
# calculates basic arithmetic operations

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text
	
	# make global variables
	lw $s6, m_w		# $s6 = m_w
	lw $s7, m_z		# $s7 = m_z
	
# The label 'main' represents the starting point
main:
# initializing values in main
	lw $s0, A		# $s0 = a
	lw $s1, B		# $s1 = b
	li $s2, 0		# initialize i = 0
	
loop:	bge $s2, 10, end	# exit loop if i >= 10
	
	li $a0, 1		# set 1 as a parameter
	li $a1, 100000		# set 100000 as a parameter
	jal random_range	# call get_random
	move $s0, $v0		# a = a = random_in_range(1,100000);
	
	li $a0, 1		# set 1 as a parameter
	li $a1, 100000		# set 100000 as a parameter
	jal random_range	# call get_random
	move $s1, $v0		# a = a = random_in_range(1,100000);
	
	move $a0, $s0		# set a as a parameter in gcd
	move $a1, $s1		# set b as a parameter in gcd
	jal gcd			# call gcd
	move $s3, $v0		# put the return value in $s2
	
	#print results to the screen
	li $v0, 4		# print_string
	la $a0, msg1		# set address to "GCD("
	syscall	
	li $v0, 1		# print_int
	la $a0, 0($s0)		# set address to A address
	syscall
	li $v0, 4		# print_string
	la $a0, msg2		# set address to ","
	syscall
	li $v0, 1		# print_int
	la $a0, 0($s1)		# set address to B address
	syscall
	li $v0, 4		# print_string
	la $a0, msg3		# set address to ") = "
	syscall
	li $v0, 1		# print_int
	la $a0, 0($s3)		# set address to result address
	syscall
	li $v0, 4		# print_string
	la $a0, nwlne		# set address to "\n"
	syscall
	
	addi $s2, $s2, 1	# i++
	j loop			# jump to top of the loop
	
end:	#stores values to memory and exits program
	sw $s0, A
	sw $s1, B
	sw $s3, final
	
	
	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit
	
gcd:	
	#push onto stack
	addi $sp, $sp, -4	# shift space on stack
	sw $s0, 0($sp)		# save $s0 to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $s1, 0($sp)		# save $s1 to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $ra, 0($sp)		# save $ra to stack
	
	#$a0 = a
	#$a1 = b
	#fuction code
	div $a0, $a1		# divide a/b
	mfhi $t0		# $t0 = a%b
	beq $t0, 0, if		# if($t0 == 0)
	#else: recursively call gcd
	move $a0, $a1		# first parameter is b
	move $a1, $t0		# second parameter is a%b
	jal gcd			# call gcd
	move $t1, $v0		# put return value in $t1
	j endGCD
	
if: 
	move $t1, $a1
	
endGCD: 
	move $v0, $t1
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# return from gcd

random_range:
	#push onto stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#function code
	move $s0, $a0		# move low parameter to $s0
	move $s1, $a1		# move high parameter to $s0
	sub $t0, $s1, $s0	# range = high-low
	addi $t0, $t0, 1	# range = high-low+1
	
	jal get_random		# call get_random
	move $t1, $v0		# put return value of get_random in $t1
	divu $t1, $t0		# rand_num/range
	mfhi $t2		# $t2 = rand_num % range
	addi $t2, $t2, 1	# $t2 = rand_num % range
	move $v0, $t2		# place $t2 as return value
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# return from random
	
	
get_random:
	#push onto stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#load constants for function
	li $t0, 36969
	li $t1, 18000
	li $t2, 65535
	
	lw $s0, m_z		# Loading global m_z from memory
	lw $s1, m_w		# Loading global m_w from memory
	
	and $t3, $s1, $t2	# (m_w&65535)
	mul $t3, $t1, $t3	# 18000*(m_w&65535)
	srl $t4, $s1, 16	# m_w>>16
	addu $s1, $t3, $t4	# z = (36969*(m_w&65535)) + (m_w>>16)
	sw $s1, m_w		# Store m_w back in memory
	
	and $t3, $s0, $t2	# (m_z&65535)
	mul $t3, $t0, $t3	# 36969*(m_z&65535)
	srl $t4, $s0, 16	# m_z>>16
	addu $s0, $t3, $t4	# z = (36969*(m_z&65535)) + (m_z>>16)
	sw $s0, m_z		# Store m_z back in memory
	
	sll $t3, $s0, 16	# m_z << 16
	addu $t3, $t3, $s1	# result = (m_z << 16) + w
	move $v0, $t3		# return location(result)
	
	
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
	
	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
A:	.word 9		# intitialize uint32_t a
B:	.word 20	# intitialize uint32_t b
final:  .word 0		# for storing the final gcd of the program

m_w:	.word 50000	# m_w = 50000
m_z:	.word 60000	# m_z = 60000

msg1:	.asciiz "GCD("	# mesg1 = "GCD("
msg2:	.asciiz ","	# mesg2 = ","
msg3:	.asciiz ") = "	# mesg3 = ") = "
nwlne:	.asciiz "\n"	# nwlne = "\n"
