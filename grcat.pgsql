# color set for pgsql cli command

#default word color
#regexp=[\w.,\:\-_/]+
#regexp=.+
#colours=green
#-

#table borders
regexp=[└╘─┌╒─═├╞─┼╪─┬─┴╧─+\-]+[┐╕┘╛┼╪─┤╡┬─┴╧─+\-]|[│|]
colours=bold red
-

#data in ( ) and ' '
regexp=\([\w\d\s,']+\)
colours=yellow
-

#numeric
regexp=\s\-?[\d\.]+\s*($|(?=[│|]))
colours=blue
-

#date
regexp=\d{4}-\d{2}-\d{2}
colours=cyan
-
#time
regexp=\d{2}:\d{2}:\d{2}(\.\d+(\+\d{2})?)?
colours=cyan
-

#IP
regexp=(\d{1,3}\.){3}\d{1,3}(:\d{1,5})?
colours=cyan
-

#schema
regexp=`\w+`
colours=yellow
-

#email
#regexp=[\w\.\-_]+@[\w\.\-_]+
regexp=\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b
colours=magenta
-

#row delimeter when using \G key
regexp=[*]+.+[*]+
count=stop
colours=white
-

#column names when using \G key
regexp=^\s*\w+:
colours=white
