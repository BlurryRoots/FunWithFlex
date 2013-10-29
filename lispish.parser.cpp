#include <string>
#include <iostream>

#include "lispish.h"

/* 
any call to this will give you an integer
representing either a token, defined in lispish.h
or zero, if there are no more tokens.
*/
extern int yylex();
/*
this function will return the value of yylineno,
which is used, to represent the line number of your input.
*/
extern int yyget_lineno( void );
/*
this function returns the string, representing the current token.
*/
extern char *yyget_text(void);
/*
this will get you the length of the current token.
*/
extern size_t yyget_leng ( void );

/*
little helper function, to interpret tokens as strings
*/
std::string GetTokenString( unsigned int someToken )
{
    std::string s;
    switch( someToken )
    {
        case COMMENT: 
            s = "COMMENT"; break;
        case LIST_BEGIN: 
            s = "LIST_BEGIN"; break;
        case LIST_END: 
            s = "LIST_END"; break;
        case IDENTIFIER: 
            s = "IDENTIFIER"; break;
        case STRING: 
            s = "STRING"; break;
        case NUMBER: 
            s = "NUMBER"; break;

        default: s = "unrecognized token!"; break;
    }

    return s;
}

/*
entry point
*/
int main( void )
{
    int token;

    /*run as long as we can find tokens*/
    while( (token = yylex()) > 0 )
    {        
        std::cout 
            << "ln: " << yyget_lineno() 
            << " -> "
            << GetTokenString( token )
            << " " << yyget_text() 
            << std::endl;
    }

    return 0;
}
