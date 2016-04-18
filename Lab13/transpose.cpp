#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void transpose_tiled(int **src, int **dest) {
	int TILE_SIZE = 32;
	for (int i = 0; i < SIZE; i += TILE_SIZE) {
		for (int j = 0; j < SIZE; j += TILE_SIZE) {
			for (int ii = i; ii < i + TILE_SIZE && ii < SIZE; ii++) {
				for (int jj = j; jj < j + TILE_SIZE && jj < SIZE; jj++) {
					dest[ii][jj] = src[jj][ii];
				}
			}
		}
	}
}
