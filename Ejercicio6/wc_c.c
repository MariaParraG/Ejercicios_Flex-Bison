/* wc_c.c — Contador de palabras en C puro (Ejercicio 6)
 *
 * Equivalente a la versión Flex, pero sin Flex.
 * Usa fread() en bloques grandes para maximizar rendimiento.
 *
 * Compilar: gcc -O2 -o wc_c wc_c.c
 * Uso:      ./wc_c < archivo.txt
 *           ./wc_c archivo1.txt archivo2.txt ...
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUF_SIZE (64 * 1024)   /* 64 KB por bloque */

/*
 * Contar palabras/líneas/chars en un FILE*.
 *
 * Estado: in_word indica si el carácter anterior fue parte de una palabra.
 * Es necesario preservarlo entre bloques para no contar mal una palabra
 * que se corta justo en el límite del buffer.
 */
void count_file(FILE *fp, const char *name,
                long *total_chars, long *total_words, long *total_lines) {

    static char buf[BUF_SIZE];
    long chars = 0, words = 0, lines = 0;
    int  in_word = 0;   /* estado: ¿estamos dentro de una palabra? */
    size_t n;

    while ((n = fread(buf, 1, BUF_SIZE, fp)) > 0) {
        for (size_t i = 0; i < n; i++) {
            unsigned char c = (unsigned char)buf[i];
            chars++;

            if (c == '\n') {
                lines++;
            }

            /*
             * Una "palabra" es una secuencia de caracteres que no son
             * espacio, tab, ni salto de línea — igual que el patrón Flex
             * [^ \t\n\r]+
             */
            if (c == ' ' || c == '\t' || c == '\n' || c == '\r') {
                in_word = 0;
            } else {
                if (!in_word) {
                    words++;
                    in_word = 1;
                }
            }
        }
    }

    if (name)
        printf("%-30s  líneas=%7ld  palabras=%7ld  caracteres=%7ld\n",
               name, lines, words, chars);

    *total_chars += chars;
    *total_words += words;
    *total_lines += lines;
}

int main(int argc, char *argv[]) {
    long total_chars = 0, total_words = 0, total_lines = 0;

    if (argc == 1) {
        /* Sin argumentos: leer stdin */
        count_file(stdin, NULL, &total_chars, &total_words, &total_lines);
        printf("líneas=%7ld  palabras=%7ld  caracteres=%7ld\n",
               total_lines, total_words, total_chars);
    } else {
        /* Con argumentos: procesar cada archivo */
        for (int i = 1; i < argc; i++) {
            FILE *fp = fopen(argv[i], "rb");
            if (!fp) {
                perror(argv[i]);
                continue;
            }
            count_file(fp, argv[i], &total_chars, &total_words, &total_lines);
            fclose(fp);
        }

        if (argc > 2) {
            /* Mostrar totales si hay más de un archivo */
            printf("%-30s  líneas=%7ld  palabras=%7ld  caracteres=%7ld\n",
                   "TOTAL", total_lines, total_words, total_chars);
        }
    }

    return 0;
}
