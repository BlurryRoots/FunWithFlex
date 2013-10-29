# Fun with flex

This project helped me to get a glimps of how to create a lexical scanner with [flex](https://en.wikipedia.org/wiki/Flex_lexical_analyser).

## Quick introduction

Flex creates a finite state machine for you, to act as a scanner. A scanner is used to identify tokens based on a given set of rules. This is especially useful for syntactical language processing.

You are going to encounter some regular expression. Therefor i would recommend reading the [flex regex documentation](http://flex.sourceforge.net/manual/Patterns.html). Also check out [regexpal](http://regexpal.com/), to see if your rule works.

## Token identification

The first step should be, to identify the tokens you want to find in your input and define them. See [lispish.h](lispish.h).

For this example, i chose a lisp-like language. See [test script](scripts/test.lispish).

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

For example:

```
my-rule-label [a-zA-Z]
```

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

In the example above, i put a return statement at the end of my code block. This is necessary if you want to fetch tokens while you scan your input. The value you return should be defined in a header file, so you can later identify your token in your parser.
If you want to use the defined token in your rules, don't forget to include your header in the first section of your lexer file.

### Section three - additional c/cpp code

Here you can write helper functions, or define previously declared prototypes.

If you want to embed your scanner somewhere else, you have to define the funtion yywrap at this point.

```
int yywrap( void )
{
    return 1;
}
```

## Creating your lexer

To create your lexer, simply call `flex my.rules.l`. This will produce a lex.yy.c containing the code to scan input, according to your rules.
Alternatively if you want to change the name of the output file, simply call `flex -o mylexer.c my.rules.l`.

## Putting it all together

To build our scanner, we need an [entry point](lispish.parser.cpp). After that, you simply build your program by calling `g++ mylexer.cpp myentrypoint.cpp -o myscanner`.

To test your scanner, you can either start it directly and get a terminal-like interface, or invoke your scanner with an input file, e.g. `myscanner < myscript.script`.

See [makefile](makfile) for more examples.
