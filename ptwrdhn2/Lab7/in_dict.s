.text

## int
## in_dict(const char *str, const char **dict, const int dict_size) {
##     for (int i = 0; i < dict_size; i++) {
##         // equivalent to if (str_cmp(str, dict[i]) == 0)
##         if (!str_cmp(str, dict[i])) {
##             return 1;
##         }
##     }
##     return 0;
## }

.globl in_dict
in_dict:
	# Your code goes here :)
	



	jr	$ra
