#include <stdio.h>

int main() {
	//for reading the file in
	char filename[256];
	FILE *file = NULL;
	//variables for the first row
	int rows;
	int cols;
	int clues;
	//variables for all other roles	
	char direction;
	int startX;
	int startY;
	char word[256];
	char hint[256];
	//for garbage collection
	char garbage;
	
	printf("Enter filename of the game: ");
	scanf("%255s", filename);
	file = fopen(filename, "r");
	
	int count = fscanf(file, "%i %i %i\n", &rows, &cols, &clues);
	//gameboard
	if(count == 3){
		for(int i=0; i<clues; i++){
			count = fscanf(file, "%c %i %i %255s %255[^\n]", 					&direction, &startX, &startY, word, hint);
			fscanf(file, "%c", &garbage);
			if(count == 5){
				printf("%s\n", hint);
			}
			else{
				printf("ERROR: not all variables matched");
			}
		}
	}
	else{
		printf("ERROR:  first line of file is invalid");
	}
	return 0;
}


