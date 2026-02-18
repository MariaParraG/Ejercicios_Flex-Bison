/* calc.y — Parser con operadores AND y OR (Ejercicio 3) */
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
%token AND OR

%type <d> expr

/*
 * Precedencia (de menor a mayor, últimas filas ganan):
 * OR  < AND  < ADD/SUB  < MUL/DIV  < unarios
 * Esto replica las convenciones habituales de C.
 */
%left OR
%left AND
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

calclist:
    /* vacío */
  | calclist line
  ;

line:
    EOL                    { /* línea vacía */ }
  | expr EOL               { printf("= %g\n", $1); }
  ;

expr:
    NUMBER                 { $$ = $1; }

  /* Aritméticos */
  | expr ADD expr          { $$ = $1 + $3; }
  | expr SUB expr          { $$ = $1 - $3; }
  | expr MUL expr          { $$ = $1 * $3; }
  | expr DIV expr          {
                               if ($3 == 0.0) { yyerror("División por cero"); $$ = 0; }
                               else $$ = $1 / $3;
                           }

  /* Valor absoluto unario: | expr | */
  | ABS expr ABS           { $$ = fabs($2); }

  /*
   * AND bitwise: convierte a long, aplica &, devuelve double.
   * Para floats, trunca a entero antes de la operación.
   */
  | expr AND expr          { $$ = (double)((long)$1 & (long)$3); }

  /*
   * OR bitwise: convierte a long, aplica |, devuelve double.
   * "||" como token separado evita el conflicto con ABS.
   */
  | expr OR  expr          { $$ = (double)((long)$1 | (long)$3); }

  /* Negación unaria */
  | SUB expr %prec UMINUS  { $$ = -$2; }

  | OP expr CP             { $$ = $2; }
  ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Calculadora con AND (&&) y OR (||)\n");
    printf("Valor absoluto sigue siendo |expr|\n\n");
    yyparse();
    return 0;
}
