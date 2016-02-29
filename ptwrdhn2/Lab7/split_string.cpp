/**
 * Compile and run using
 * clang++ -Wall -o split_string split_string.cpp
 * ./split_string
 */

#include <cstdio>
#include <cassert>

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
    // false is 0, true is anything else
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
in_dict(const char *str, const char **dict, const int dict_size) {
    for (int i = 0; i < dict_size; i++) {
        // equivalent to if (str_cmp(str, dict[i]) == 0)
        if (!str_cmp(str, dict[i])) {
            return 1;
        }
    }
    return 0;
}

/**
 * TEST CASES
 */

void
test_str_cmp() {
    assert(str_cmp("", "") == 0);
    assert(str_cmp("a", "") == 1);
    assert(str_cmp("", "b") == 1);
    assert(str_cmp("a", "ab") == 1);
    assert(str_cmp("ab", "a") == 1);
    assert(str_cmp("ab", "ab") == 0);

    printf("str_cmp(\"\", \"\") is %d\n", str_cmp("", ""));
    printf("str_cmp(\"a\", \"\") is %d\n", str_cmp("a", ""));
    printf("str_cmp(\"a\", \"a\") is %d\n", str_cmp("a", "a"));
    printf("str_cmp(\"\", \"b\") is %d\n", str_cmp("", "b"));
    printf("str_cmp(\"b\", \"b\") is %d\n", str_cmp("b", "b"));
    printf("str_cmp(\"a\", \"ab\") is %d\n", str_cmp("a", "ab"));
    printf("str_cmp(\"ab\", \"a\") is %d\n", str_cmp("ab", "a"));
    printf("str_cmp(\"ab\", \"ab\") is %d\n", str_cmp("ab", "ab"));
    printf("str_cmp(\"this is a string!\", \"this is a string!\") is %d\n", str_cmp("this is a string!", "this is a string!"));
}

void
test_in_dict() {
    const char *test_dict[] = {"a", "ab", "abc"};
    assert(in_dict("", test_dict, 3) == 0);
    assert(in_dict("a", test_dict, 3) == 1);
    assert(in_dict("abc", test_dict, 3) == 1);
    assert(in_dict("c", test_dict, 3) == 0);

    printf("in_dict(\"\", test_dict, 3) is %d\n", in_dict("", test_dict, 3));
    printf("in_dict(\"a\", test_dict, 3) is %d\n", in_dict("a", test_dict, 3));
    printf("in_dict(\"abc\", test_dict, 3) is %d\n", in_dict("abc", test_dict, 3));
    printf("in_dict(\"c\", test_dict, 3) is %d\n", in_dict("c", test_dict, 3));
}

int
main() {
    test_str_cmp();
    printf("\n");
    test_in_dict();
    return 0;
}
