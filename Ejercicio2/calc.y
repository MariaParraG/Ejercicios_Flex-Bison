/* calc.y — Parser con salida en decimal y hexadecimal (Ejercicio 2) */
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
    EOL                    { /* línea vacía */ }
  | expr EOL               {
                               /* Mostrar resultado en decimal Y hexadecimal */
                               printf("= %g (0x%lX)\n", $1, (unsigned long)(long)$1);
                           }
  ;

expr:
    NUMBER                 { $$ = $1; }
  | expr ADD expr          { $$ = $1 + $3; }
  | expr SUB expr          { $$ = $1 - $3; }
  | expr MUL expr          { $$ = $1 * $3; }
  | expr DIV expr          {
                               if ($3 == 0.0) {
                                   yyerror("División por cero");
                                   $$ = 0;
                               } else {
                                   $$ = $1 / $3;
                               }
                           }
  | ABS expr ABS           { $$ = fabs($2); }
  | OP expr CP             { $$ = $2; }
  ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Calculadora Hex/Decimal — ingresa expresiones:\n");
    printf("  Hex: 0xFF, 0x1A   Decimal: 42, 3.14\n\n");
    yyparse();
    return 0;
}
