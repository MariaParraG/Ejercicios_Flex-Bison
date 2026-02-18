/* calc.l — Scanner para la calculadora básica (Ejercicio 1) */
%{
#include "calc.tab.h"
#include <math.h>
%}

%%
"/*"([^*]|"*"[^/])*"*/"  { /* ignorar comentarios */ }
[0-9]+(\.[0-9]+)?         { yylval.d = atof(yytext); return NUMBER; }
"+"                        { return ADD; }
"-"                        { return SUB; }
"*"                        { return MUL; }
"/"                        { return DIV; }
"|"                        { return ABS; }
"("                        { return OP; }
")"                        { return CP; }
\n                         { return EOL; }
[ \t]                      { /* ignorar espacios */ }
.                          { printf("Carácter desconocido: %c\n", *yytext); }
%%

int yywrap(void) { return 1; }
