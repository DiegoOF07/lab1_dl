%{
#include <stdio.h>
#include <stdlib.h>

int line = 1;

void print_token(const char* type, const char* value) {
    printf("Token(%s, \"%s\") at line %d\n", type, value, line);
}
%}


LETTER      [a-zA-Z]
DIGIT       [0-9]
HEX         [0-9a-fA-F]

ID          ({LETTER}|_)(({LETTER}|{DIGIT}|_)*)

INTEGER     {DIGIT}+
FLOAT       {DIGIT}+"."{DIGIT}+
SCIENTIFIC  ({DIGIT}+("."{DIGIT}+)?)[eE][+-]?{DIGIT}+
HEXNUM      0[xX]{HEX}+

STRING      \"([^\\\n]|(\\.))*\"

%%

/* ----- Comentarios (se descartan) ----- */

"//".*                      { /* Ignorar comentario línea */ }

"/*"([^*]|\*+[^*/])*\*+"/"  { /* Ignorar comentario multilinea */ }

/* ----- Strings ----- */

{STRING}        { print_token("STRING", yytext); }

/* ----- Operadores Relacionales ----- */

"=="            { print_token("REL_OP", yytext); }
"!="            { print_token("REL_OP", yytext); }
"<="            { print_token("REL_OP", yytext); }
">="            { print_token("REL_OP", yytext); }
"<"             { print_token("REL_OP", yytext); }
">"             { print_token("REL_OP", yytext); }

/* ----- Operadores Lógicos ----- */

"&&"            { print_token("LOGIC_OP", yytext); }
"||"            { print_token("LOGIC_OP", yytext); }
"!"             { print_token("LOGIC_OP", yytext); }

/* ----- Operadores Aritméticos ----- */

"+"             { print_token("ARITH_OP", yytext); }
"-"             { print_token("ARITH_OP", yytext); }
"*"             { print_token("ARITH_OP", yytext); }
"/"             { print_token("ARITH_OP", yytext); }

/* ----- Números ----- */

{SCIENTIFIC}    { print_token("SCIENTIFIC", yytext); }
{FLOAT}         { print_token("FLOAT", yytext); }
{HEXNUM}        { print_token("HEX", yytext); }
{INTEGER}       { print_token("INTEGER", yytext); }

/* ----- Identificadores ----- */

{ID}            { print_token("IDENTIFIER", yytext); }

/* ----- Espacios ----- */

[ \t\r]+        { /* Ignorar espacios */ }
\n              { line++; }

/* ----- Error ----- */

.               { printf("ERROR: %s at line %d\n", yytext, line); }

%%

int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Cannot open file %s\n", argv[1]);
            return 1;
        }
    }

    printf("Scanning...\n\n");
    yylex();
    return 0;
}
