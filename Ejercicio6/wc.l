/* wc.l — Contador de palabras en Flex (Ejercicio 6) */
%{
int chars   = 0;
int words   = 0;
int lines   = 0;
%}

%%
[^ \t\n\r]+   { words++; chars += yyleng; }
\n            { chars++; lines++; }
.             { chars++; }
%%

int main(void) {
    yylex();
    printf("líneas=%7d  palabras=%7d  caracteres=%7d\n",
           lines, words, chars);
    return 0;
}

int yywrap(void) { return 1; }
