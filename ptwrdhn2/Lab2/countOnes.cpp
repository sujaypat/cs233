/**
 * @file
 * Contains the implementation of the countOnes function.
 */
#include <iostream>
using namespace std;
unsigned countOnes(unsigned input) {
	// TODO: write your code here

  unsigned int odd = input & 0x55555555;
  unsigned int even = input & 0xAAAAAAAA;
    
  even >>= 1;
  input = odd + even;
    
  //alternate in twos
  odd = input & 0x33333333;
  even = input & 0xCCCCCCCC;
  even >>= 2;
  input = odd + even;
    
  //alternate in fours
  odd = input & 0x0F0F0F0F;
  even = input & 0xF0F0F0F0;
  even >>= 4;
  input = odd + even;
    
  //alternate in eights
  odd = input & 0x00FF00FF;
  even = input & 0xFF00FF00;
  even >>= 8;
  input = odd + even;
    
  //alternate in 16s
  odd = input & 0x0000FFFF;
  even = input & 0xFFFF0000;
  even >>= 16;
  input = odd + even;
    
  return input;

}
