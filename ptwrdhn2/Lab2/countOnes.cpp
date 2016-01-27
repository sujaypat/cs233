/**
 * @file
 * Contains the implementation of the countOnes function.
 */
#include <iostream>
using namespace std;
unsigned countOnes(unsigned input) {
	// TODO: write your code here

  unsigned oddCounters = input & 0x5555;
  unsigned evenCounters = input & 0xAAAA;

  unsigned pairAndAdded = (evenCounters >> 1) + oddCounters;

  cout << pairAndAdded << endl;

	

	return input;
}
