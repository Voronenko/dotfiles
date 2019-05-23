# Two very basic functions for searching just the input code of an IPython notebook
# Written because I often want to search notebooks for snippets but the giant output
# of embedded encoded images makes it difficult.

# Ipython's nbconvert can be used to extract just the input, but this requires 
# writing to a separate file and can be quite slow when used with large notebooks.
# Additionally, find/xargs can be used with igrep when the name of the notebook isn't known.

# icat could be used to convert an IPython notebook to a standard python file if 
# the notebook does not contain whole-cell magics.

# Michelle L. Gill, 2014/06/21

# Both functions require jq for parsing the IPython notebook json: http://stedolan.github.io/jq/manual/
# icat also optionally uses pygments, which is an IPython dependency http://pygments.org/docs/cmdline/
function icat {
	jq '.worksheets[].cells[] | select(.cell_type=="code") | .input[]' $1 \
	| sed 's/^"//g;s/"$//g;s/\\n$//g;s/\\"/"/g;s/\\\\/\\/g' \
	| pygmentize -l python
}

# File name is specified last and all other arguments are assumed to belong to grep
# This approximates grep's standard behavior
# The slicing of $argv may not work in Bash. Honestly, you should be using zsh though.
function igrep {
	jq '.worksheets[].cells[] | select(.cell_type=="code") | .input[]' $argv[-1] \
	| sed 's/^"//g;s/"$//g;s/\\n$//g;s/\\"/"/g;s/\\\\/\\/g' \
	| grep $argv[1,-2] 
}

# This simple function will clear the output cells in a notebook. This can then be 
# redirected into a new file from the command line
function clearoutput {
	jq '. | .worksheets[].cells[].outputs=[] ' $1
}
