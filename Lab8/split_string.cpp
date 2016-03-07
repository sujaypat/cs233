#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/**
 * struct for dictionary
 */
struct dictionary {
    int size;
    const char *words[100];
};

/**
 * compare two strings src and tgt
 * @param: src source string
 * @param: tgt target string
 * @return: 0 if the two strings are the same
 */
int
str_cmp(const char *src, const char *tgt) {
    for (; *src && *tgt; src++, tgt++) {
        if (*src != *tgt) {
            break;
        }
    }
    return *src != *tgt;
}

/**
 * check whether a string is in the dictionary
 * @param: str the target string
 * @param: dict an array of strings
 * @param: dict_size the size of dictionary
 * @return: 1 if the string is in the dictionary
 */
int
in_dict(char *str, const char **dict, const int dict_size) {
    for (int i = 0; i < dict_size; i++) {
        if (!str_cmp(str, dict[i])) {
            return 1;
        }
    }
    return 0;
}

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

/**
 * split a string into consecutive sub strings,
 * such that each string is in the dictionary
 * store each sub string into a given array
 * @param: solution a char* array to store solution
 * @param: str the target string to split
 * @param: dict a pointer to dictionary_t
 * @return: 1 if the string is splittable, 0 otherwise
 */
int
split_string(char **solution, const char *str, const dictionary *dict) {
    *solution = NULL;
    const char *ptr = str;
    if (*ptr == 0) {
        return 1;
    }
    for (; *ptr != 0; ptr++) {
        char *prefix = sub_str(str, ptr + 1 - str);
        if (in_dict(prefix, (const char **)dict->words, dict->size)) {
            if (split_string(solution + 1, ptr + 1, dict)) {
				// if the prefix is in dictionary and
		        // if the rest of the string is also "splittable"
		        // insert the prefix into solution
				*solution = prefix;
                return 1;
            }
        }
    }
    return 0;
}

/**
 * helper function to print an array of string
 */
void
print(char **solution) {
    for (; *solution; solution++) {
        printf("%s ", *solution);
    }
    printf("\n");
}

void
test_split_string0() {
    const char *long_string = "helloworld";
    const dictionary mydict = {
    	2,
    	{"hello", "world"},
    };
    char **solution = (char **)calloc(256, sizeof(char *));

    int retval = split_string(solution, long_string, &mydict);
    printf("%i ", retval);
    print(solution);
}

void
test_split_string1() {
    const char *long_string = "aaaabbbbcccc";
    const dictionary mydict = {
    	3,
    	{"a", "bb", "cccc"},
    };
    char **solution = (char **)calloc(256, sizeof(char *));

    int retval = split_string(solution, long_string, &mydict);
    printf("%i ", retval);
    print(solution);
}

void
test_split_string2() {
    const char *long_string = "bbb";
    const dictionary mydict = {
    	3,
    	{"a", "bb", "cccc"},
    };
    char **solution = (char **)calloc(256, sizeof(char *));

    int retval = split_string(solution, long_string, &mydict);
    printf("%i ", retval);
    print(solution);
}

int
main() {
    test_split_string0();
    test_split_string1();
    test_split_string2();
    return 0;
}
