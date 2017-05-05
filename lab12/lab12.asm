# Code for lab 12
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
# get random seeds from user
	li $v0, 4		# print_string
	la $a0, num1		# set address to "Seed Rand\nNumber1:\n"
	syscall	
	li $v0, 5		# read_int
	syscall
	sw $v0, m_z		# m_z = input
	
	li $v0, 4		# print_string
	la $a0, num2		# set address to "Number2:\n"
	syscall	
	li $v0, 5		# read_int
	syscall
	sw $v0, m_w		# m_w = input
	
	jal playGame		# call playGame
	
	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

# Decides who goes first and runs turns for each player	
playGame:

	#push to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $s0, 0($sp)		# save $s0 to stack
	addi $sp, $sp, -4	# shift space on stack
	sw $ra, 0($sp)		# save $ra to stack
	
	la $s0, board		# $s0 = board[]
	li $s1, 0		# gameover = 0	
	
	move $a0, $s0		# make board a parameter
	jal fillAlternate	# call fillAlternate
	
	move $a0, $s0		# make boad a parameter
	jal fillDots		# call fillDots
	
	jal get_random		# call get_random
	move $s2, $v0		# $s2 = getrandom()
	
	li $t4, 2		# $t4 = 2
	div $s2, $t4		# $s2 % 2
	mfhi $s3		# %s3 = $s2 % 2
	
	beq $s3, 0, player1st	# $s2%2 == 0
	li $v0, 4		# print_string
	la $a0, comptrn		# set address to "Computer goes first\n"
	syscall	
	j playGameDo		# go to do-while loop
player1st:
	li $v0, 4		# print_string
	la $a0, humtrn		# set address to "Human goes first\n"
	syscall	
	j playGameDo		# go to do-while loop
	
playGameDo:
	li $t4, 2		# $t4 = 2
	div $s2, $t4		# $s2 % 2
	mfhi $s3		# %s3 = $s2 % 2
	beq $s3, 0, humTurn	# $s2%2 == 0
	move $a0, $s0		# make board a parameter
	jal computerMove	# call computerMove
	
	addi $s2, $s2, 1	# $s2++
	
	move $a0, $s0		# set board as parameter
	li $a1, 'C'		# set 'C' as parameter
	jal checkWin		# call checkWin
	move $t0, $v0		# $t0 = checkWin()
	beq $t0, 1, compWin	# $t0 == 1
	
	j playGameDo		# loop back to the top
	
humTurn:
	move $a0, $s0		# make board a parameter
	jal humanMove		# call humanMove
	
	addi $s2, $s2, 1	# $s2++
	
	move $a0, $s0		# set board as parameter
	li $a1, 'H'		# set 'H' as parameter
	jal checkWin		# call checkWin
	move $t0, $v0		# $t0 = checkWin()
	beq $t0, 1, humWin	# $t0 == 1
	
	j playGameDo		# loop back to the top
	
compWin:
	move $a0, $s0		# set board as parameter
	jal printBoard		# call printBoard
	
	la $t0, cwin		# $t0 = cwin
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to cwin
	syscall
	j endGame		# go to endGame

humWin:
	move $a0, $s0		# set board as parameter
	jal printBoard		# call printBoard
	
	la $t0, hwin		# $t0 = hwin
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to hwin
	syscall
	j endGame		# go to endGame

endGame:
	
	#pop from stack 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# go back to function that called playGame
	
fillAlternate:
	#push to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4	# shift space on stack
	sw $ra, 0($sp)		# save $ra to stack
	
	li $s0, 'C'		# $s0 = 'C'
	li $s1, 'H'		# $s1 = 'H'
	
	sb $s0, 0($a0)		# board[0] = C
	sb $s0, 8($a0)		# board[8] = C
	sb $s1, 9($a0)		# board[9] = H
	sb $s1, 17($a0)		# board[17] = H
	sb $s0, 18($a0)		# board[18] = C
	sb $s0, 26($a0)		# board[26] = C
	sb $s1, 27($a0)		# board[27] = H
	sb $s1, 35($a0)		# board[35] = H
	sb $s0, 36($a0)		# board[36] = C
	sb $s0, 44($a0)		# board[44] = C
	sb $s1, 45($a0)		# board[45] = H
	sb $s1, 53($a0)		# board[53] = H
	
	#pull from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# go back to fucntion that called fillAlternate
	
fillDots:
	#push to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4	
	sw $ra, 0($sp)
	
	li $s0, '.'		# $s0 = '.'
	li $s1, 0		# $s1 = 0
	li $t0, 9		# $t0 = 9
	
fillDotsWhile:
	bgt $s1, 5, fillDotsEnd	# while($s1 <= 5)
	li $s2, 1		# i = 1
fillDotsFor:
	beq $s2, 8, fillDotsForEnd #for(i = 1; i < 8; i++)
	mul $t1, $t0, $s1	# $t1 = $s1*9
	add $t1, $t1, $s2	# $t1 = i + $s1*9
	add $a0, $a0, $t1	# board[$t1]
	sb $s0, 0($a0)		# board[$t1] = '.'
	sub $a0, $a0, $t1	# board[0]
	addi $s2, $s2, 1	# i++
	j fillDotsFor		# loop back to top of the for loop
	
fillDotsForEnd:
	addi $s1, $s1, 1	# $s1++ 
	j fillDotsWhile		# loop back to top of the while
	

fillDotsEnd:	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from fillDots
	
humanMove:
	#push to stack
	addi $sp, $sp, -4
	sw $s2, ($sp)
	addi $sp, $sp, -4
	sw $s1, ($sp)
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		# $s0 = board
	li $s1, 0		# valid = 0
	move $s0, $a0		# set board as parameter
	jal printBoard		# call printBoard
	
humanMoveDo:
	la $t0, columnq		# $t0 = columnq
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to "What column would you like to drop token into? Enter 1-7: \n"
	syscall
	
	li $v0, 5		# read_int
	syscall
	move $s2, $v0		# column = input
	
	blt $s2, 1, humanMoveDo	# column < 1
	bgt $s2, 7, humanMoveDo # column > 7
	
	move $a0, $s0		# set board as parameter
	move $a1, $s2		# set column as parameter
	jal isFull		# call isFull
	move $s1, $v0		# valid = isFull()
	beq $s1, 1, humanMoveEnd# valid == 1
	la $t0, fullcol		# $t0 = fullCol
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to "That column is full\n"
	j humanMoveDo		# go back to top of loop
	
humanMoveEnd:
	move $a0, $s0		# set board as parameter
	move $a1, $s2		# set column as parameter
	li $a2, 'H'		# set 'H' as a parameter
	jal addToColumn		# call addToColumn
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# automates the computer's move	
computerMove:
	#push to stack
	addi $sp, $sp, -4
	sw $s2, ($sp)
	addi $sp, $sp, -4
	sw $s1, ($sp)
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		# $s0 = board
	
	li $s1, 0		# valid = 0
computerMoveDo:
	li $a0, 1		# set 1 as parameter
	li $a1, 7		# set 7 as parameter
	jal random_range	# call random_range
	move $s2, $v0		# column = random_range()
	
	blt $s2, 1, computerMoveDo# if(column < 1)
	bgt $s2, 7, computerMoveDo# if(column > 7)
	
	move $a0, $s0		# set board as parameter
	move $a1, $s2		# set column as parameter
	jal isFull		# call isFull
	move $s1, $v0		# valid = isFull()
	beq $s1, 1, computerAdd	# if(valid == 1)
	j computerMoveDo	# loop back to the top
	
computerAdd:
	la $t0, selected	# $t0 = "Computer selected column "
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to "Computer selected column "
	syscall
	
	li $v0, 1		# print_int
	move $a0, $s2		# printf(column)
	syscall
	
	la $t0, nwlne		# $t0 = "\n"
	li $v0, 4		# print_string
	move $a0, $t0		# printf("\n")
	syscall
	
	move $a0, $s0		# set board as parameter
	move $a1, $s2		# set column as parameter
	li $t4, 'C'		# $t4 = 'C'
	move $a2, $t4 		# set 'C' as parameter
	jal addToColumn		# call addToColumn
	
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# adds character to selected column
addToColumn:
	#push to stack
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $s0, 7		# i = 7
	la $t1, '.'		# $t1 = '.'
addToColumnLoop:
	blt $s0, 0, addToColumnEnd# for(i >= 0)
	li $t0, 9		# index = 9
	mul $t0, $t0, $s0	# index = 9*i
	add $t0, $t0, $a1	# index = column + 9*i
	add $a0, $a0, $t0	# board[index]
	lbu $t4, 0($a0)		# $t4 = board[index]
	beq $t4, $t1, emptySpot# if(board[index] == '.')
	sub $a0, $a0, $t0	# board[0]
	sub $s0, $s0, 1		# i--
	j addToColumnLoop	# loop back to top
	
emptySpot:
	sb $a2, 0($a0)		# board[index] = token
	sub $a0, $a0, $t0	# board[0]
	
addToColumnEnd:
	#pull from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			# return from addToColumn

# checks if a given column is full
isFull:
	#push to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0		# $t0 = board
	move $t1, $a1		# $t1 = column
	add $t0, $t0, $t1	# board[column]
	lbu $t4, 0($t0)		# $t4 = board[column]
	li $t3, '.'		# $t3 = '.'
	beq $t4, $t3, isFullTrue# if(board[column] == '.')
	li $v0, 0		# return 0
	sub $t0, $t0, $t1	# board[0]
	j isFullEnd		# go to end of function
	
isFullTrue:
	li $v0, 1		# return 1
	sub $t0, $t0, $t1	# board[0]
	j isFullEnd		# go to end of function
	
isFullEnd:
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra	

# Prints the board to the screen	
printBoard:
	#push to stack
	addi $sp, $sp, -4
	sw $s1, ($sp)
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, numbers		# $t0 = "  1 2 3 4 5 6 7  \n"
	move $s1, $a0		# $s1 = board
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to "  1 2 3 4 5 6 7  \n"
	syscall
	
	la $t0, dashes		# $t0 = "-----------------\n"
	li $v0, 4		# print_string
	la $a0, 0($t0)		# set address to "-----------------\n"
	syscall
	
	li $s0, 0		# i = 0
printBoardFor:
	bge $s0, 54, printBoardForExit	# i<54
	add $s1, $s1, $s0	# board[i]
	li $v0, 11		# print_char
	lb $a0, 0($s1)		# printf(board[i])
	syscall
	
	la $t0, space		# $t0 = " "
	li $v0, 4		# print_string
	la $a0, 0($t0)		#printf(" ")
	syscall
	 
	sub $s1, $s1, $s0	# board[0]
	addi $s0, $s0, 1	# index = i+1
	li $t1, 9		# $t1 = 9
	div $s0, $t1		# index = index%9
	mfhi $t1		# $t1 = $t0%$t1
	bne $t1, 0, printBoardFor# if(index == 0)
	
	la $t1, nwlne		# $t1 = "\n"
	li $v0, 4		# print_string
	la $a0, 0($t1)		#printf("\n")
	syscall
	
	j printBoardFor		# loop back to top of the for loop 
	

printBoardForExit:	
	li $v0, 4		# print_string
	la $a0, dashes		# set address to "-----------------\n"
	syscall
	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

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

# see if a certain letter has won	
checkWin:
	#push onto stack
	addi $sp, $sp, -4
	sw $s2, 0($sp)
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0		# $s0 = board[]
	move $t5, $a0		# set $t5 as backup board
	move $s1, $a1		# $s1 = token
	li $t0, 9		# $t0 = 9
	
	#check verticals
	li $s2, 1		# i = 1
loop1:
	beq $s2, 8, loop2_set	# for(i < 8)

	li $s3, 0		# j = 0	
loop1_1:
	mul $t1, $s3, $t0	# index = 9*j
	add $t1, $t1, $s2	# index = i+9*j
	add $s0, $s0, $t1	# board[index]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop1_1itr # board[index] == token
	addi $s0, $s0, 9	# board[index+9]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop1_1itr # board[index+9] == token
	addi $s0, $s0, 9	# board[index+18]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop1_1itr # board[index+18] == token
	addi $s0, $s0, 9	# board[index+37]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop1_1itr # board[index+37] == token
	addi $s0, $s0, 9	# board[index+36]
	lbu $t4, 0($s0)		# $t4 = board[index]
	beq $t4, $s1, win # board[index+36] == token
loop1_1itr:
	move $s0, $t5		# board[0]
	addi $s3, $s3, 1	# j++
	blt $s3, 2, loop1_1	# for(j < 2)
	
	addi $s2, $s2, 1	# i++
	j loop1			# back to top of loop1

loop2_set:
	#check horizontals
	li $s2, 0		# i = 0
loop2:
	beq $s2, 6, loop3_set	# for(i < 6)
	
	li $s3, 0		# j = 0
loop2_1:
	mul $t1, $s2, $t0	# index = 9*i
	add $t1, $t1, $s3	# index = j+9*i
	add $s0, $s0, $t1	# board[index]	
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop2_1itr # board[index] == token
	addi $s0, $s0, 1	# board[index+1]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop2_1itr # board[index+1] == token
	addi $s0, $s0, 1	# board[index+2]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop2_1itr # board[index+2] == token
	addi $s0, $s0, 1	# board[index+3]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop2_1itr # board[index+3] == token
	addi $s0, $s0, 1	# board[index+4]
	lbu $t4, 0($s0)		# $t4 = board[index]
	beq $t4, $s1, win # board[index+4] == token
loop2_1itr:
	move $s0, $t5		# board[0]
	addi $s3, $s3, 1	# j++	
	blt $s3, 5, loop2_1	# for(j < 5)
	
	addi $s2, $s2, 1	# i++
	j loop2			# back to top of loop2

loop3_set:
	#check diagonals from the top
	li $s2, 0		# i = 0	
loop3:
	beq $s2, 2, loop4_set	# for(i<2)
	
	li $s3, 0		# j = 0
loop3_1:
	mul $t1, $s2, $t0	# index = 9*i
	add $t1, $t1, $s3	# index = j+9*i
	add $s0, $s0, $t1	# board[index]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_1itr # board[index] == token
	addi $s0, $s0, 10	# board[index+10]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_1itr # board[index+10] == token
	addi $s0, $s0, 10	# board[index+20]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_1itr # board[index+20] == token
	addi $s0, $s0, 10	# board[index+30]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_1itr # board[index+30] == token
	addi $s0, $s0, 10	# board[index+40]
	lbu $t4, 0($s0)		# $t4 = board[index]
	beq $t4, $s1, win # board[index+40] == token
loop3_1itr:
	move $s0, $t5		# board[0]
	addi $s3, $s3, 1	# j++
	blt $s3, 5, loop3_1	# for(j < 5)
	
	li $s3, 8		# j = 8
loop3_2:
	mul $t1, $s2, $t0	# index = 9*i
	add $t1, $t1, $s3	# index = j+9*i
	add $s0, $s0, $t1	# board[index]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_2itr # board[index] == token
	addi $s0, $s0, 8	# board[index+8]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_2itr # board[index+8] == token
	addi $s0, $s0, 8	# board[index+16]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_2itr # board[index+16] == token
	addi $s0, $s0, 8	# board[index+24]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop3_2itr # board[index+24] == token
	addi $s0, $s0, 8	# board[index+32]
	lbu $t4, 0($s0)		# $t4 = board[index]
	beq $t4, $s1, win # board[index+32] == token
loop3_2itr:
	move $s0, $t5		# board[0]
	addi $s3, $s3, -1	# j--
	bgt $s3, 3, loop3_2	# for(j < 5)
	
	addi $s2, $s2, 1	# i++
	j loop3			# back to top of loop3
	
loop4_set:
	#check diagonals from bottom
	li $s2, 5		# i = 5
loop4:
	beq $s2, 3, loss	# for(i > 3)
	
	li $s3, 0		# j = 0
loop4_1:
	mul $t1, $s2, $t0	# index = 9*i
	add $t1, $t1, $s3	# index = j+9*i
	add $s0, $s0, $t1	# board[index]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_1itr # board[index] == token
	addi $s0, $s0, -8	# board[index-8]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_1itr # board[index-8] == token
	addi $s0, $s0, -8	# board[index-16]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_1itr # board[index-16] == token
	addi $s0, $s0, -8	# board[index-24]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_1itr # board[index-24] == token
	addi $s0, $s0, -8	# board[index-32]
	lbu $t4, 0($s0)		# $t4 = board[index]
	beq $t4, $s1, win # board[index-32] == token
loop4_1itr:
	move $s0, $t5		# board[0]
	addi $s3, $s3, 1	# j++
	blt $s3, 5, loop4_1	# for(j < 5)
	
	addi $s2, $s2, -1	# i--
	
	li $s3, 8		# j = 8
loop4_2:
	mul $t1, $s2, $t0	# index = 9*i
	add $t1, $t1, $s3	# index = j+9*i
	add $s0, $s0, $t1	# board[index]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_2itr # board[index] == token
	addi $s0, $s0, -10	# board[index-10]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_2itr # board[index-10] == token
	addi $s0, $s0, -10	# board[index-20]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_2itr # board[index-20] == token
	addi $s0, $s0, -10	# board[index-30]
	lbu $t4, 0($s0)		# $t4 = board[index]
	bne $t4, $s1, loop4_2itr # board[index-30] == token
	addi $s0, $s0, -10	# board[index-40]
	lbu $t4, 0($s0)		# $t4 = board[index]
	beq $t4, $s1, win 	# board[index-40] == token
loop4_2itr:
	move $s0, $t5		# board[0]
	addi $s3, $23, -1	# j--
	bgt $s3, 3, loop4_2	# for(j > 3)
	
	addi $s2, $s2, -1	# i--
	j loop4			# back to top of loop4
	

loss:	
	li $v0, 0		# return 0, didnt win
	j checkWinEnd		# jump to the end of checkwin
win:
	li $v0, 1		# return 1, found a winner

checkWinEnd:	
	#pop from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	lw $s3, 0($sp)
	addi $sp, $sp, 4
	lw $s2, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra			#return from function
	
	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)


m_w:	.word 50000		# m_w = 50000
m_z:	.word 60000		# m_z = 60000
board:	.byte 0:54		# board[54]

num1:	.asciiz "Seed Rand\nNumber1:\n"	# num1 = "Seed Rand\nNumber1:\n"
num2:	.asciiz "Number2:\n"		# num2 = "Number2:\n"
humtrn: .asciiz "Human goes first\n"	# humtrn = "Human goes first\n"
comptrn:.asciiz "Computer goes first\n"	# comptrn = "Computer goes first\n"
numbers:.asciiz "  1 2 3 4 5 6 7  \n"	# numbers = "  1 2 3 4 5 6 7  \n"
dashes:	.asciiz "-----------------\n"	# dashes = "------------------\n"
space:	.asciiz " "			# space = " "
columnq:.asciiz "What column would you like to drop token into? Enter 1-7: \n" # columnq = "What column would you like to drop token into? Enter 1-7: \n"
fullcol:.asciiz "That column is full\n" # fullcol = "That column is full\n"
selected:.asciiz "Computer selected column " # selected = "Computer selected column "
cwin:	.asciiz  "Computer Won!" # cwin = "Computer Won!"
hwin:	.asciiz  "You Won!"  # hwin = "You Won!"
nwlne:	.asciiz "\n"	# nwlne = "\n"
