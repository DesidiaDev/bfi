# bfi
A lightweight, low-size brainfuck interpreter

USE

To compile, simple run the makefile.

run with "./bfi TEXTFILE" to run a brainfuck program from a text file

run with "./bfi" for it to read from STDIN

DETAILS

It's a very simple interpreter built with the objective of minimizing the compiled file size.
The only error catching it does is spotting an unbalanced number of while begin and while end
commands and telling you if the textfile you wanted to run cant be opened (the ability to run
off the edge of memory is considered a feature). All characters other than brainfuck commands 
are considered as comments. It supports up to 10Kb programs and has a 10Kb memory space (the
ability to increase memory space by running over and into program memory is considered a feature).

HOW TO BRAINFUCK

you have a chunk of memory initialized to 0 and a pointer that starts at 0

">" - increment pointer by 1

"<" - decrement pointer by 1

"+" - increment byte at location of pointer by 1

"-" - decrement byte at location of pointer by 1

"." - write byte at location of pointer to stdout

"," - read stdin into the location of pointer

"[" - begin while on condition of byte at pointer being greater than 0

"]" - end while\n
