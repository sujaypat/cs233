.text

## int
## split_string(char **solution, char *str, const dictionary *dict) {
##     *solution = NULL;
##     char *ptr = str;
##     if (*ptr == 0) {
##         return 1;
##     }
##     for (; *ptr != 0; ptr++) {
##         char *prefix = sub_str(str, ptr + 1 - str);
##         if (in_dict(prefix, dict->words, dict->size)) {
##             if (split_string(solution + 1, ptr + 1, dict)) {
##                 // if the prefix is in dictionary and
##                 // if the rest of the string is also "splittable"
##                 // insert the prefix into solution
##                 *solution = prefix;
##                 return 1;
##             }
##         }
##     }
##     return 0;
## }


.globl split_string
split_string:
	# Your code goes here :)
	jr	$ra

