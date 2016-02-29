.text

## int
## str_cmp(const char *src, const char *tgt) {
##     for (; *src && *tgt; src++, tgt++) {
##         if (*src != *tgt) {
##             break;
##         }
##     }
##     // false is 0, true is anything else
##     return *src != *tgt;
## }

.globl str_cmp
str_cmp:
	# Your code goes here :)
	jr	$ra
