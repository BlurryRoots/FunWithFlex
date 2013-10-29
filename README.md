# Fun with flex

This project helped me to get a glimps of how to create a lexical scanner with [flex](https://en.wikipedia.org/wiki/Flex_lexical_analyser).

## Quick introduction

Flex creates a finite state machine for you, to act as a scanner. A scanner is used to identify tokens based on a given set of rules. This is especially useful for syntactical language processing.

## Lexer rules

To provide flex with a set of rules, you have to write a definition file. This file usually ends with .l, but you are pretty much free to use any other ending.

In there you find three mayor sections.
( For actual code, see lispish.l )

### Section one - declarations

In here you can do two things. First you are able to write c/cpp code in a block.
For example:

```
%{
#include "yourawesomeheaderfile.h"

void your_awesome_prototype();
%}
```


Next you might want to declare the rules for identifing a token. A rule is a label followed by a regular expression.

### Section two - behaviours

In this section, you are able to specify c/cpp code, which should be run, when encountering a certain token.

The genral syntax for behaviours is a rule followed by code.
If you have specified a rule via lable in section one, you can refer to a lable by putting it in curly braces.

For example:

```
{my-rule-label} printf( "found my-rule-label!" );
```

In case you do not want to use rule labels you can put the rule directly in front of your code, like this:

```
[a-zA-Z] printf( "found a word!" );
```

It might be necessary to write more than one line of code. In that case you simply put curly braces around your code block. But beware, your code block has to start in the same line as your rule/label. You must also have at least one space between your rule/label and the start of your code block.

For example:

```
[1-9][0-9]* {
    printf( "found an integer!" );
    return INTEGER;
}
```

In the example above, i put a return statement at the end of my code block. This is necessary if you want to fetch tokens while you scan your input. But we will come to that later.

### Section three - additional c/cpp code

Here you can write helper functions, or define previously declared prototypes.

If you want to embed your scanner somewhere else, you have to define the funtion yywrap at this point.

```
int yywrap( void )
{
    return 1;
}
```
