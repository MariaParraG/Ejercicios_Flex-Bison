/* handscanner.c — Scanner escrito a mano equivalente al Ejemplo 1-4 (Ejercicio 4)
 *
 * Compara el comportamiento con la versión Flex. Imprime los tokens reconocidos
 * para que puedas verificar si ambos escáneres producen la misma secuencia.
 *
 * Compilar: gcc -o handscanner handscanner.c
 * Uso:      echo "3 + 0.5 * 2" | ./handscanner
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/* Tipos de token — mismos que en el ejemplo Flex */
typedef enum {
    TOK_NUMBER,
    TOK_ADD,
    TOK_SUB,
    TOK_MUL,
    TOK_DIV,
    TOK_ABS,
    TOK_OP,
    TOK_CP,
    TOK_EOL,
    TOK_EOF,
    TOK_ERROR
} TokenType;

typedef struct {
    TokenType type;
    double    value;   /* válido solo para TOK_NUMBER */
} Token;

/* ------------------------------------------------------------------ */
/* Leer el siguiente token desde stdin                                  */
/* ------------------------------------------------------------------ */
Token next_token(void) {
    Token tok;
    int c;

top:
    c = getchar();

    /* Ignorar espacios y tabulaciones */
    if (c == ' ' || c == '\t') goto top;

    /* EOF */
    if (c == EOF) {
        tok.type = TOK_EOF;
        return tok;
    }

    /* Nueva línea */
    if (c == '\n') {
        tok.type = TOK_EOL;
        return tok;
    }

    /* Comentarios /* ... */
    if (c == '/') {
        int next = getchar();
        if (next == '*') {
            /* Estamos dentro de un comentario: avanzar hasta encontrar */ */
            int prev = 0;
            while ((c = getchar()) != EOF) {
                if (prev == '*' && c == '/') goto top;  /* fin comentario */
                prev = c;
            }
            /* EOF dentro de comentario: error */
            tok.type = TOK_ERROR;
            return tok;
        } else {
            /* No era un comentario: devolver '/' y poner 'next' de vuelta */
            ungetc(next, stdin);
            tok.type = TOK_DIV;
            return tok;
        }
    }

    /* Número: [0-9]+(\.[0-9]+)?
     *
     * DIFERENCIA vs Flex: Flex NO reconoce ".5" (sin dígito inicial) con el
     * patrón [0-9]+(\.[0-9]+)? porque exige al menos un dígito antes del punto.
     * Este scanner manual tampoco lo hace, para ser equivalente.
     */
    if (isdigit(c)) {
        char buf[64];
        int  i = 0;

        buf[i++] = (char)c;

        /* Parte entera */
        while (isdigit(c = getchar()))
            buf[i++] = (char)c;

        /* Parte decimal */
        if (c == '.') {
            buf[i++] = '.';
            while (isdigit(c = getchar()))
                buf[i++] = (char)c;
        }

        /* Devolver el carácter que no pertenece al número */
        ungetc(c, stdin);
        buf[i] = '\0';

        tok.type  = TOK_NUMBER;
        tok.value = atof(buf);
        return tok;
    }

    /* Operadores de un carácter */
    switch (c) {
        case '+': tok.type = TOK_ADD; return tok;
        case '-': tok.type = TOK_SUB; return tok;
        case '*': tok.type = TOK_MUL; return tok;
        case '|': tok.type = TOK_ABS; return tok;
        case '(': tok.type = TOK_OP;  return tok;
        case ')': tok.type = TOK_CP;  return tok;
    }

    /* Carácter desconocido */
    fprintf(stderr, "Carácter desconocido: '%c'\n", c);
    tok.type = TOK_ERROR;
    return tok;
}

/* ------------------------------------------------------------------ */
/* Nombre del token para imprimir                                       */
/* ------------------------------------------------------------------ */
const char *token_name(TokenType t) {
    switch (t) {
        case TOK_NUMBER: return "NUMBER";
        case TOK_ADD:    return "ADD(+)";
        case TOK_SUB:    return "SUB(-)";
        case TOK_MUL:    return "MUL(*)";
        case TOK_DIV:    return "DIV(/)";
        case TOK_ABS:    return "ABS(|)";
        case TOK_OP:     return "OP(()";
        case TOK_CP:     return "CP())";
        case TOK_EOL:    return "EOL";
        case TOK_EOF:    return "EOF";
        default:         return "ERROR";
    }
}

/* ------------------------------------------------------------------ */
/* main: tokenizar stdin e imprimir cada token                         */
/* ------------------------------------------------------------------ */
int main(void) {
    printf("Scanner manual — Ejercicio 4\n");
    printf("Ingresa expresiones (Ctrl+D para salir):\n\n");

    Token tok;
    while ((tok = next_token()).type != TOK_EOF) {
        if (tok.type == TOK_NUMBER)
            printf("  TOKEN: %-12s  valor = %g\n", token_name(tok.type), tok.value);
        else
            printf("  TOKEN: %s\n", token_name(tok.type));
    }

    printf("  TOKEN: EOF\n");
    return 0;
}
