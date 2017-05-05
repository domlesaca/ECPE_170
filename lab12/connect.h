#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

void fillAlternate(char board[]);
void fillDots(char board[]);
void printBoard(char board[]);
int isFull(char board[], int column);
void addToColumn(char board[], int column, char token);
void playerMove(char board[]);
void playGame();
uint32_t random_in_range(uint32_t low, uint32_t high);
uint32_t get_random();
void fluch();
