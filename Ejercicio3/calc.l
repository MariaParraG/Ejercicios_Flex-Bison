/* calc.l — Scanner con operadores AND (&&) y OR (||) (Ejercicio 3) */
%{
#include "calc.tab.h"
#include <stdlib.h>
#include <math.h>
%}

%%
"/*"([^*]|"*"[^/])*"*/"  { /* ignorar comentarios */ }

[0-9]+(\.[0-9]+)?         { yylval.d = atof(yytext); return NUMBER; }

"+"                        { return ADD; }
"-"                        { return SUB; }
"*"                        { return MUL; }
"/"                        { return DIV; }

/*
 * IMPORTANTE: "||" debe ir ANTES que "|" solo.
 * Flex usa "maximal munch": siempre elige el token más largo posible.
 * Si "|" estuviera primero en el archivo, "||" se leería como dos ABS.
 */
"||"                       { return OR;  }   /* OR  binario */
"&&"                       { return AND; }   /* AND binario */
"|"                        { return ABS; }   /* valor absoluto unario */

"("                        { return OP; }
")"                        { return CP; }
\n                         { return EOL; }
[ \t]                      { /* ignorar espacios */ }
.                          { printf("Carácter desconocido: %c\n", *yytext); }
%%

int yywrap(void) { return 1; }
