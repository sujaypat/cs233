/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include "extractMessage.h"

using namespace std;

string extractMessage(const bmp & image) {
	string message;

	// TODO: write your code here
	// http://en.cppreference.com/w/cpp/string/basic_string#Operations might be of use
	// because image is a const reference, any pixel you get needs to be stored in a const pointer
	// i.e. you need to do
	// const pixel * p = image(x, y);
	// just doing
	// pixel * p = image(x, y);
	// would give a compilation error
	int width = image.width();
	int height  = image.height();
	BMP out(width, height);
	
	for(int i = 0; i < height; ++i){
	  for(int j = 0; j < width; ++i){
	    
	    *image(i,j)->green

	  }

	}



	return message;
}
