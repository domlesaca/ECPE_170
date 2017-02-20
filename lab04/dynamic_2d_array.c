// Multi-dimensional array code based on FAQ at:
// http://c-faq.com/aryptr/dynmuldimary.html

// Dominic Lesaca
// d_lesaca@u.pacific.edu

#include <stdio.h>   // Allows printf, ...
#include <string.h>
#include <stdlib.h>  // Allows malloc, ...
#include <errno.h>   // Allows errno

char** createArray(int rows, int cols);
void fillArray(char** myArray, int rows, int cols);
void printArray(char** myArray, int rows, int cols);
void deleteArray(char** myArray, int rows);

/*int main(void) {
  const int ROWS = 4;
  const int COLS = 8;
  int** myArray;
  
  myArray = createArray(ROWS, COLS);
  fillArray(myArray, ROWS, COLS);
  printArray(myArray, ROWS, COLS);
  deleteArray(myArray, ROWS, COLS);
  
  return EXIT_SUCCESS;
}*/

char** createArray(int rows, int cols) {
  char **myArray;
  
  // Allocate a 1xROWS array to hold pointers to more arrays
  myArray = calloc(rows, sizeof(char *));
  if (myArray == NULL) {
    printf("FATAL ERROR: out of memory: %s\n", strerror(errno));
    exit(EXIT_FAILURE);
  }
  
  // Allocate each row in that column
  for (int i = 0; i < rows; i++) {
    myArray[i] = calloc(cols, sizeof(char));
    if (myArray[i] == NULL) {
      printf("FATAL ERROR: out of memory: %s\n", strerror(errno));
      exit(EXIT_FAILURE);
    }
  }
  
  return myArray;
}

void fillArray(char** myArray, int rows, int cols) {
  
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      myArray[i][j] = '#';//fills out all spots with a #
    }
  }
  
  return;
}

void printArray(char** myArray, int rows, int cols) {
	printf("\t  ");
	for (int h = 1; h <= cols; h++) {
		printf("%i ", h);//prints numbers on top
	}
	printf("\n\t-------------------------------\n");
	for (int i = 0; i < rows; i++) {
  		printf("%i\t| ", i+1);
  		for (int j = 0; j < cols; j++) {
    			printf("%c ", myArray[i][j]);//prints each character
   		}
  		printf("\n");
	}
}

void deleteArray(char** myArray, int rows) {
  for (int i = 0; i < rows; i++) {
    free(myArray[i]);
  }
  free(myArray);
  
  return;
}
