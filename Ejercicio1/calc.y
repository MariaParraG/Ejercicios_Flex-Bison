/* calc.y — Parser con soporte para líneas vacías/solo-comentario (Ejercicio 1) */
%{
#include <stdio.h>
#include <math.h>
void yyerror(char *s);
int yylex(void);
%}

%union {
    double d;
}

%token <d> NUMBER
%token ADD SUB MUL DIV ABS OP CP EOL

%type <d> expr

%%

calclist:
    /* vacío */
  | calclist line
  ;

line:
    EOL                    { /* línea vacía o solo-comentario: no hacer nada */ }
  | expr EOL               { printf("= %g\n", $1); }
  ;

expr:
    NUMBER                 { $$ = $1; }
  | expr ADD expr          { $$ = $1 + $3; }
  | expr SUB expr          { $$ = $1 - $3; }
  | expr MUL expr          { $$ = $1 * $3; }
  | expr DIV expr          { $$ = $1 / $3; }
  | ABS expr ABS           { $$ = fabs($2); }
  | OP expr CP             { $$ = $2; }
  ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Calculadora con soporte para comentarios\n");
    printf("Ingresa expresiones o comentarios /* ... */:\n");
    yyparse();
    return 0;
}
