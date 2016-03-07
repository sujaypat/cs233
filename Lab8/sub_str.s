.text

## char * 
## sub_str(char *str, size_t n) {
##     char *newstr = (char *)malloc(n + 1);
##     int len = 0;
##     for (len = 0 ; len < n && str[len] != '\0' ; len++) {
##         newstr[len] = str[len]; 
##     }
##     newstr[len] = '\0';
##     return newstr;
## }

.globl sub_str
sub_str:
	# Your code goes here :)
    jr  $ra