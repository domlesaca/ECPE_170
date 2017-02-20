#include <stdio.h>
#include <string.h>

// Dominic Lesaca
// d_lesaca@u.pacific.edu

struct Clue {//structure that holds all of the data on the clue
	char word[256];
	char hint[256];
	int startRow;
	int startCol;
	char direction;
	int found;//for whether or not it bas been guessed yet
};

char** createArray(int rows, int cols);
void fillArray(char** myArray, int rows, int cols);
void printArray(char** myArray, int rows, int cols);
void deleteArray(char** myArray, int rows);


//takes words from struct and adds them to the array
void addWordsToArray(char** myArray, struct Clue clue) {
  //cycles through every character in the string
  for(int i = 0; i < strlen(clue.word); i++) {
  	if(clue.direction == 'H'){//checks if horizonal or vertical
  		if(clue.found == 1){//checks if has been found
  			//character if if has been found
  			myArray[clue.startRow-1][clue.startCol+i-1] = clue.word[i];
  		}
  		else{
  			//adds a '_' if not found yet
  			myArray[clue.startRow-1][clue.startCol+i-1] = '_';
  		}
  	}
  	else{
  		if(clue.found == 1){
  			myArray[clue.startRow+i-1][clue.startCol-1] = clue.word[i];
  		}
  		else{
  			myArray[clue.startRow+i-1][clue.startCol-1] = '_';
  		}
  	}
  }
  
  return;
}


//contains all game logic
void playGame(char** board, struct Clue clues[], int numClues, int rows, int cols) {
	printf("Game has %i words. \n", numClues);//prints info on the game
	int numSolved = 0;//used to track if the game is finished
	while(numSolved < numClues) {//checks if all clues have been solved
		printf("Current Puzzle: \n");
		printArray(board, rows, cols);
		printf("Unsolved Clues: \n");
		printf("#\tDirection\tRow/Col\tCLue\n");
		for(int i = 0; i<numClues; i++){//prints all remaining clues
			if(clues[i].found == 0){
				printf("%i:\t%c\t%i/%i\t%s\n", i+1, clues[i].direction,
					clues[i].startRow, clues[i].startCol,
					clues[i].hint);
			}
		}
		printf("Enter clue to solve or -1 to exit: ");
		int clueNum;
		scanf("%i", &clueNum);
		if(clueNum == -1){//checks for an escape command
			printf("Bye\n");
			return;
		}
		else if (clueNum > numClues || clueNum < 0){//checks for an invalid number
			printf("Invalid Entry\n");
		}
		else if(clues[clueNum-1].found == 1){
			//checks if that number has been solved
			printf("You already got that one.\n");
		}
		else{//plays the game
			char guess[256];
			printf("Enter your solution: ");
			scanf("%255s", guess);
			for(int x = 0; x < strlen(guess); x++){//sets the gues to a capital
				guess[x] = toupper(guess[x]);
			}
			if(strcmp(guess, clues[clueNum-1].word) != 0) {
				//checks if answer is wrong
				printf("WRONG!!!\n");
			}
			else{
				printf("correct!\n");
				clues[clueNum-1].found = 1;//sets the word as found
				//adds guessed word
				addWordsToArray(board, clues[clueNum-1]);
				numSolved++;//add to number of solved clues
			}	
		}
	}
	printArray(board, rows, cols);
	printf("YOU WIN!!!\n");
	return;	
}

int main(void) {
	//for reading the file in
	char filename[256];
	FILE *file = NULL;
	
	//variables for the first row
	int rows;
	int cols;
	int clues;
	
	//for garbage collection
	char garbage;
	
	printf("Enter filename of the game: ");
	scanf("%255s", filename);
	file = fopen(filename, "r");
	
	int count = fscanf(file, "%i %i %i\n", &rows, &cols, &clues);
	
	// create clue structs
	struct Clue words[clues];
	
	//gameboard
	if(count == 3){//checks if line was valid
		//set up board
		char** board = createArray(rows, cols);
		fillArray(board, rows, cols);
		
		//get all data for each word
		for(int i=0; i<clues; i++){
		//scans for all values in the line
			count = fscanf(file, "%c %i %i %255s %255[^\n]", 					&words[i].direction, &words[i].startRow, 					&words[i].startCol, words[i].word, words[i].hint);
				words[i].found = 0;
			fscanf(file, "%c", &garbage);//dumps garbage
			if(count == 5){//checsk if line was valid
				//adds words to board as underscores
				addWordsToArray(board, words[i]);
			}
			else{
				printf("ERROR: not all variables matched");
			}
		}
		//start game
		playGame(board, words, clues, rows, cols);
		deleteArray(board, rows);
		
	}
	else{
		printf("ERROR:  first line of file is invalid");
	}
	return 0;
};


