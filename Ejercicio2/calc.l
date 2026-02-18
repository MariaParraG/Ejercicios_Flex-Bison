/* calc.l — Scanner con soporte para números hexadecimales (Ejercicio 2) */
%{
#include "calc.tab.h"
#include <stdlib.h>
%}

%%
"/*"([^*]|"*"[^/])*"*/"  { /* ignorar comentarios */ }

0x[a-fA-F0-9]+            {
                               /* Número hexadecimal: 0x1A, 0xFF, etc. */
                               yylval.d = (double)strtol(yytext, NULL, 16);
                               return NUMBER;
                           }

[0-9]+(\.[0-9]+)?         {
                               /* Número decimal (entero o flotante) */
                               yylval.d = atof(yytext);
                               return NUMBER;
                           }

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
