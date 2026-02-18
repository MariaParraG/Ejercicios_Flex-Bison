# Ejercicio 2 — Soporte para números hexadecimales

## Pregunta

> Convertir la calculadora en una calculadora hexadecimal que acepte tanto números hex como decimales. En el scanner agregar un patrón como `0x[a-f0-9]+`, usar `strtol` para convertir el valor, almacenarlo en `yylval`, retornar un token `NUMBER`. Ajustar el `printf` de salida para mostrar el resultado en decimal y hex.

## Solución

### Scanner (`calc.l`)

Se agrega la regla para reconocer literales hexadecimales **antes** de la regla decimal (las reglas Flex se aplican en orden de declaración; la más larga gana por "maximal munch"):

```lex
0x[a-fA-F0-9]+   { yylval.d = strtol(yytext, NULL, 16); return NUMBER; }
[0-9]+           { yylval.d = atof(yytext); return NUMBER; }
```

### Parser (`calc.y`)

El `printf` de resultado se ajusta para mostrar ambas representaciones:

```c
printf("= %g (0x%lX)\n", $1, (unsigned long)$1);
```

## Archivos

| Archivo  | Descripción                                   |
|----------|-----------------------------------------------|
| `calc.l` | Scanner con soporte hex + decimal             |
| `calc.y` | Parser con salida en decimal y hexadecimal    |

## Compilar y ejecutar

```bash
flex calc.l
bison -d calc.y
gcc -o calc lex.yy.c calc.tab.c -lfl -lm
```

## Ejemplos de uso

```
0xff + 1        →  = 256 (0x100)
0x1A * 2        →  = 52 (0x34)
255 + 0x01      →  = 256 (0x100)
10 + 5          →  = 15 (0xF)
```
