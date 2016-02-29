/**
 * Compile and run using
 * clang++ -Wall -o crc_encoding crc_encoding.cpp
 * ./crc_encoding
 */

#include <cstdio>
#include <cassert>

#define UNSIGNED_SIZE 32

void print_binary(unsigned num);

/*
 * return the number of bits in a binary number
 */
int
length(unsigned binary) {
    int num_bits = 0;
    for (; binary > 0 && num_bits < UNSIGNED_SIZE; num_bits++) {
        binary = binary >> 1;
    }
    return num_bits;
}

/*
 * represent the polynomial as a binary number
 * if the polynomial contains an x^n term,
 * then the (n+1)th bit from right is set to 1
 * i.e. x^3+x+1 represented as 1011
 * @param: dividend represents the original message M(x) to encode
 * @param: divisor represents the shared polynomial C(x)
 * @return: the encoded message using crc
 */

unsigned
crc_encoding(unsigned dividend, unsigned divisor) {
    int divisor_length = length(divisor);
    // append zeros to the dividend
    unsigned remainder = dividend << (divisor_length - 1);
    int remainder_length = length(remainder);
    // long division
    // terminate when remainder is smaller than the divisor
    for (int i = remainder_length; i >= divisor_length; i--) {
        unsigned msb = remainder >> (i - 1);
        // print_binary(remainder); // debug printout
        // equivalent to if (msb != 0)
        if (msb) {
            // xor the top divisor_length bits of remainder with divisor
            remainder = remainder ^ (divisor << (i - divisor_length));
        }
    }
    // print_binary(remainder); // debug printout
    // add the remainder back to dividend to generate the message
    return (dividend << (divisor_length - 1)) ^ remainder;
}

/*
 * helper function print out numbers in binary
 */
void
print_binary(unsigned binary) {
    for (int i = UNSIGNED_SIZE - 1; i >= 0; i--) {
        printf("%d", (binary & (1 << i)) >> i);
    }
    printf("\n");
}

/*
 * Test Cases
 */

void
test_length() {
    assert(length(0x0) == 0);
    assert(length(0x1) == 1);
    assert(length(0x2) == 2);
    assert(length(0x7) == 3);
    assert(length(0x4d0) == 11);
    assert(length(0xd) == 4);

    printf("length(0x0) is %d\n", length(0x0));
    printf("length(0x1) is %d\n", length(0x1));
    printf("length(0x2) is %d\n", length(0x2));
    printf("length(0x7) is %d\n", length(0x7));
    printf("length(0x4d0) is %d\n", length(0x4d0));
    printf("length(0xd) is %d\n", length(0xd));
}

void
test_crc_encoding() {
    // x^7+x^4+x^3+x  x^3+x^2+1	    x^10+x^7+x^6+x^4+x^2+1
    // 1001 1010	1101	    100 1101 0101
    assert(crc_encoding(0x9a, 0xd) == 0x4d5);
    printf("crc_encoding(0x9a, 0xd) is %x\n", crc_encoding(0x9a, 0xd));

    // x^10+x^5+x^4+x^2    x^4+1	x^14+x^9+x^8+x^6+x+1
    // 100 0011 0100	   1 0001	100 0011 0100 0011
    assert(crc_encoding(0x434, 0x11) == 0x4343);
    printf("crc_encoding(0x434, 0x11) is %x\n", crc_encoding(0x434, 0x11));
}

int
main() {
    test_length();
    printf("\n");
    test_crc_encoding();
    return 0;
}
