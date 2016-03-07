#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/**
 * construct a prefix of the given string of length n
 * @param: str the original string
 * @param: n the length of the prefix
 * @return: a new string of length n
 */
char * 
sub_str(const char *str, size_t n) {
    char *newstr = (char *)malloc(n + 1);
    int len = 0;
    for (len = 0 ; len < n && str[len] != '\0' ; len++) {
        newstr[len] = str[len]; 
    }
    newstr[len] = '\0';
    return newstr;
}

void
test_sub_str() {
    printf("%s\n", sub_str("", 0));
    printf("%s\n", sub_str("a", 1));
    printf("%s\n", sub_str("abc", 2));
    printf("%s\n", sub_str("abc", 4));
}

int
main() {
    test_sub_str();
    return 0;
}
