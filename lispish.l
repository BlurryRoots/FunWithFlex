%{
    #include <iostream>
    #include "lispish.h"

    void print_error();
%}

list_begin  \(
list_end    \)

number      (0|([1-9][0-9]*))(\.[0-9]+)?
asciistring \'[^']*\'
identifier  [^'() \n\t0-9][^'() \n\t]*

comment     \/\*[ -~]*\*\/

whitespaces [ \t]
new_line    [\n]

any         .

%%

{comment} {
    return COMMENT;
}


{list_begin} {
    return LIST_BEGIN;
}


{list_end} {
    return LIST_END;
}


{number} {
    return NUMBER;
}

{asciistring} {
    return STRING;
}

{identifier} {
    return IDENTIFIER;
}


{new_line} {
    yylineno++;
}
                 
{whitespaces} {
    ;
}
               

{any} {
    print_error();
}

%%

void print_error()
{
    std::cout << "unexpected expression!" << std::endl;
}

int yywrap( void )
{
    return 1;
}
