#? - Conditional operator that assigns a value to a variable based on some condition

$VAR$=($CONDITION$)?$VAL1$:$VAL2$
do - Loop 'do-while' execute the code block once, before checking if the condition.
do {
  $END$
} while ($CONDITION$);
for - Loop 'for' with index
len = $ARRAY$.length;
for ($INDEX$ = 0; $INDEX$<len; $INDEX$ += 1) {
    $VAR$ = $ARRAY$[$INDEX$];
    $END$
}

#forin - Loop 'for-in' loops through the properties of an object
for (prop in $OBJ$) {
    if ($OBJ$.hasOwnProperty(prop)) {
        $END$
    }
}

#if - 'if' statement
if ($CONDITION$) {
    $END$
}


#ife - 'if-else' statement
if ($CONDITION$) {
    $END$
} else {

}

#ifeif - 'if-else if -else' statement
if ($CONDITION$) {
    $END$
} else if ($NEXTCONDITION$) {

} else {

}

#switch - 'switch' statement
switch ($EXPRESSION$) {
case $EXPVALUE1$:
    $END$
    break;
case $EXPVALUE2$:

    break;
default:

}

#throw - Throw new error
throw new $ERRTYPE$('$MSG$', '$MODULENAME$');
try - 'try-catch' statement
try {
    $END$
} catch (err) {

}

#while - Loop 'while' loops through a block of code with condition
while ($CONDITION$) {
    $END$
}

#fn - Create new function
function ($PARAMETERS$) {
    'use strict';
    var me = this;
    $END$
}
