#include <stdio.h>

int main() {
	FILE * puzzleFile;
	char * line = NULL;
	size_t len = 0;
	ssize_t read;
	
	printf("Hello, World\n");
	puzzleFile = fopen("crossword_puzzle.txt", "r");
	while ((read = getline(&line, &len, puzzleFile)) != -1) {
		printf("%s", line);
	}
	return 0;
}


