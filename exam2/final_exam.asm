# Code for final exam MIPS half
# SUms an array
# Dominic Lesaca
# ECPE 170

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text
	
# The label 'main' represents the starting point

# register map for main
# 	$s0 = array
# 	$s1 = arraySize
# 	$s2 = i
#	$t0 = used for print messages

main:
# initializing values in main
	la $s0, array		
	lw $s1, arraySize
			
	li $s2, 0
forloop:
	# run condion for the loop
	bge $s2, $s1, endMain
	
	# print message1
	li $v0 4
	la $a0, msg1
	syscall
	
	# prinf i
	li $v0, 1
	move $a0, $s2
	syscall
	
	# message 2
	li $v0, 4
	la $a0, msg2
	syscall
	
	mul $t0, $s2, 4
	add $s0, $s0, $t0
	li $v0, 1
	lw $a0, 0($s0)
	syscall
	sub $s0, $s0, $t0
	
	li $v0, 4
	la $a0, nwlne
	syscall	
	
	addi $s2, $s2, 1
	
	j forloop
	
# used to get out of the loop	
endMain:
	#call arraySum
	move $a0, $s0
	move $a1, $s1
	jal arraySum
	
	move $t0, $v0
	
	# message 3
	li $v0, 4
	la $a0, msg3
	syscall
	
	# prinf sum
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, nwlne
	syscall	
	
	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit


# Sums all of the elements in an array	
arraySum:	
	#push onto stack
	addi $sp, $sp, -4	# shift space on stack
	sw $s0, 0($sp)		# save $s0 to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $s1, 0($sp)		# save $s1 to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $s2, 0($sp)		# save $s1 to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $ra, 0($sp)		# save $ra to stack
	
# register map for arraySum
	#$s0 = int* array
	#$s1 = int arraySize
	#$s2 = result
	#$t0 = arraySize-1 and result from arraySum
	
	#fuction code
	move $s0, $a0
	move $s1, $a1
	
	#if arraySize == 0
	beq $s1, 0, eql0
	#else
	#recusrively call arraySum
	addi $t0, $s1, -1
	la $a0, 4($s0)
	move $a1, $t0
	jal arraySum
	#get result from recursive call
	move $t0, $v0
	
	lw $t1, 0($s0)
	add $s2, $t1, $t0
	j endfunc
	
	

eql0:
	li $s2, 0
	
endfunc:
	move $v0, $s2
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# return from gcd


	
	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
array:	.word 2, 3, 5, 7, 11	# intitialize array[] = {2, 3, 5, 7, 11}
arraySize:	.word 5		# intitialize arraySize = 5

msg1:	.asciiz "Array["	# mesg1 = "Array["
msg2:	.asciiz "]="		# mesg2 = "]="
msg3:	.asciiz "Sum of array is "		# mesg3 = "Sum of array is "
nwlne:	.asciiz "\n"		# nwlne = "\n"
