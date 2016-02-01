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
	
	int w = image.width();
	int h = image.height();
	int nextPixel = 0;
	int max = 7; // max 3bit unsigned value
	unsigned char null = 0;
	unsigned char letter = 0;
    
	for (int i = 0; i < h; i++) {
	  for (int j = 0; j < w; j++) {
            const pixel * p = image (j, i );
            unsigned char last = p->green & 0x01;
            int currentPlace = max - nextPixel;
            letter ^= (last << currentPlace);
            
            if (nextPixel == max && letter != null) {
	      message.push_back (letter);
	      nextPixel = null;
	      letter = null;
            }else {
	      ++nextPixel;
            }
            
	  }
        
	}

	return message;
}
