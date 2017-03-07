#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "arrays.h"

int main() {
	uint32_t array1[3][5]; // 2D array
	uint32_t array2[3][5][5];  // 3D array
	
	for (int i = 0; i < 3; i++) {
		for(int j = 0; j < 5; j++) {
			printf("array1[%i][%i] is at address %p \n", i, j, &array1[i][j]);
		}	
	}
	
	printf("\n");
	
	for (int i = 0; i < 3; i++) {
		for(int j = 0; j < 5; j++) {
			for(int h = 0; h < 5; h++) {
				printf("array2[%i][%i][%i] is at address %p \n", i, j, h, &array2[i][j][h]);
				}
		}	
	}
	
	printf("\nWhen reading the addresses of each spot in the array, we can see that \n each address increments by 4.  This shows that the array is column split \n as the addresses go in order based on changes to the inner most array first.\n");
}


