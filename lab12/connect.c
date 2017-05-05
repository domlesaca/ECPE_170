// Dominic Lesaca
// ECPE 170
// Lab 12 C code

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include "connect.h"

uint32_t m_w = 50000;
uint32_t m_z = 60000;

//Adds the alternating characters to columns 0 and 8
void fillAlternate(char board[]) {
	// row 1
	board[0] = 'C';
	board[8] = 'C';
	// row 2
	board[9] = 'H';
	board[17] = 'H';
	// row 3
	board[18] = 'C';
	board[26] = 'C';
	// row 4
	board[27] = 'H';
	board[35] = 'H';
	// row 5
	board[36] = 'C';
	board[44] = 'C';
	// row 6
	board[45] = 'H';
	board[53] = 'H';	
}

// Places dots in all un filled spots on the board
void fillDots(char board[]) {
	int factor9 = 0;
	// while loop moves us to the next row
	while(factor9 <= 5) {
		for(int i = 1; i < 8; i++) {
			int index = i + (9*factor9);
			board[index] = '.';
		}
		
		factor9 += 1;
	}
}

// Prints the board to the screen
void printBoard(char board[]) {
	printf("  1 2 3 4 5 6 7  \n");
	printf("-----------------\n");
	for(int i = 0; i < 54; i++) {
		printf("%c ", board[i]);
		if((i+1)%9 == 0) {
			printf("\n");
		}
	}
	printf("-----------------\n");
}

// checks if a selected column is full
int isFull(char board[], int column) {
	// if the top spot is a '.' then there is still room in the column
	if(board[column] == '.') {
		return 1; //not full
	}
	return 0; //is full
}

// add a character to a column
void addToColumn(char board[], int column, char token) {
	for(int i = 7; i >= 0; i--) {
		int index = column+(9*i); // get index based on the offset and column
		if(board[index] == '.') {
			board[index] = token;
			break;
		}
	}
}

void playerMove(char board[]) {
	int column;
	char nl;
	int valid = 0; //default to an invalid move, 1 will mean valid
	printBoard(board);
	do {
		printf("What column would you like to drop token into? Enter 1-7: ");
		while(scanf("%d", &column) == 0) {
			printf("Not a valid integer\n");
			printf("Enter 1-7: \n");
			flush();
		}
		if(column > 7 || column < 1) {
			printf("Only valid columns are 1-7\n");
		}
		else {
			valid = isFull(board, column);
			if(valid == 0) {printf("That column is full\n");}
		}
	}while(valid == 0);
	
	addToColumn(board, column, 'H');
	
}

// runs the coputer's move
void computerMove(char board[]) {
	int valid = 0;
	do {
		uint32_t column = random_in_range(1, 7); // pick random column
		valid = isFull(board, column);
		if(valid == 1) {
		printf("Computer selected column %d\n", column);
			addToColumn(board, column, 'C');
		}
	}while(valid != 1);	
}

// checks to see if a player won
int checkWin(char board[], char token) {
	int won = 0; //default to losing
	//check vertical
	for(int i = 1; i < 8; i++) {
		for(int j = 0; j < 2; j++) {
			if(board[i+(9*j)]==token && board[i+(9*j)+9]==token && 
			   board[i+(9*j)+18]==token && board[i+(9*j)+27]==token && 
			   board[i+(9*j)+36]==token) {
			   	won = 1;
			   }
		}
	}
	//check horizontal
	for(int i = 0; i< 6; i++) {
		for(int j = 0; j < 5; j++) {
			if(board[j+(9*i)]==token && board[j+(9*i)+1]==token && 
			board[j+(9*i)+2]==token && board[j+(9*i)+3]==token && 
			board[j+(9*i)+4]==token) {
				won = 1;
			}
		}
	}
	//check diagonal
	//from top
	for(int i = 0; i < 2; i++) {
		//from the top left
		for(int j = 0; j < 5; j++) {
			if(board[j+(9*i)] == token && board[j+(9*i)+10] == token && 
			board[j+(9*i)+20] == token && board[j+(9*i)+30] == token && 
			board[j+(9*i)+40] == token) {
				won = 1;
			}
		}
		//from top right
		for(int j = 8; j > 3; j--) {
			if(board[j+(9*i)] == token && board[j+(9*i)+8] == token && 
			board[j+(9*i)+16] == token && board[j+(9*i)+24] == token && 
			board[j+(9*i)+32] == token) {
				won = 1;
			}
		}
	}
	//from bottom
	for(int i = 5; i > 3; i--) {
		//from the bottom left
		for(int j = 0; j < 5; j++) {
			if(board[j+(9*i)] == token && board[j+(9*i)-8] == token && 
			board[j+(9*i)-16] == token && board[j+(9*i)-24] == token && 
			board[j+(9*i)-32] == token) {
				won = 1;
			}
		}
		//from the bottom right
		for(int j = 8; j > 3; j--) {
			if(board[j+(9*i)] == token && board[j+(9*i)-10] == token && 
			board[j+(9*i)-20] == token && board[j+(9*i)-30] == token && 
			board[j+(9*i)-40] == token) {
				won = 1;
			}
		}
	}
	return won;
}

//Handles turns for player and computer
void playGame() {
	char board[54];
	
	fillAlternate(board);
	fillDots(board);
	int gameOver = 0;
	int coin = get_random();
	if(coin%2 == 0) {
		printf("Human turn first.\n");
	}
	else {
		printf("Computer turn first\n");
	}
	do {
		if(coin%2 == 0) {
			playerMove(board);
			if(checkWin(board, 'H') == 1) {
				printBoard(board);
				printf("You Won!!!\n");
				gameOver = 1;
			}
			else {coin++;}
		}
		else {
			computerMove(board);
			printBoard(board);
			if(checkWin(board, 'C') == 1) {
				printf("Computer Won.\n");
				gameOver = 1;
			}
			else {coin++;}
		}
	}while(gameOver == 0);
	
}

//prevents infinite loops on invlaid input
void flush() {
	char c;
	while((c=getchar())!='\n');
	getchar();
}

int main(int argc, char* argv[]) {
	int x = -1;
	int y = -1;
	do {
		printf("Enter two positive numbers to initialize the random number generator.\n");
		printf("Number 1: \n");
		while(scanf("%d", &x) == 0) {
			printf("invalid\nNumber 1: \n");
			flush();
		}
		printf("Number 2: ");
		while(scanf("%d", &y) == 0) {
			printf("invalid\nNumber 2: \n");
			flush();
		}
	}while(x < 0 || y < 0);
	m_w = x;
	m_z = y;
	playGame();
	return 0;
}

// Generate random number in range [low, high]
// (i.e. including low and high)
uint32_t random_in_range(uint32_t low, uint32_t high)
{
  uint32_t range = high-low+1;
  uint32_t rand_num = get_random();

  return (rand_num % range) + low;
}


// Generate random 32-bit unsigned number
// based on multiply-with-carry method shown
// at http://en.wikipedia.org/wiki/Random_number_generation
uint32_t get_random()
{
  uint32_t result;
  m_z = 36969 * (m_z & 65535) + (m_z >> 16);
  m_w = 18000 * (m_w & 65535) + (m_w >> 16);
  result = (m_z << 16) + m_w;  /* 32-bit result */
  return result;
}

