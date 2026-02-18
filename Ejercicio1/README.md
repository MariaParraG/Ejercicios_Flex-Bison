# Ejercicio 1 — Comentarios en la calculadora (Flex & Bison)

## Pregunta

> ¿Aceptará la calculadora una línea que contenga **solo un comentario**? ¿Por qué no? ¿Sería más fácil corregirlo en el scanner o en el parser?

## Análisis

### ¿Por qué falla?

La calculadora del libro define una línea como:

```
line : expr EOL
```

Si una línea contiene únicamente un comentario (p.ej. `/* hola */`), el scanner descarta el comentario y solo envía el token `EOL` al parser. El parser espera `expr EOL`, pero recibe solo `EOL`, lo que produce un **error de sintaxis**.

### ¿Dónde es más fácil corregirlo?

**En el parser** es la solución más limpia. Basta con agregar una producción alternativa:

```
line : expr EOL
     | EOL          /* línea vacía o solo comentario */
     ;
```

Corregirlo en el scanner requeriría enviar un token ficticio o manejar lógica adicional para detectar el final de línea después de un comentario — más complejo y menos semántico.

## Solución

Se modifica el parser (`calc.y`) para aceptar líneas vacías o de solo-comentario.

## Archivos

| Archivo       | Descripción                        |
|---------------|------------------------------------|
| `calc.l`      | Scanner Flex (sin cambios)         |
| `calc.y`      | Parser Bison con la corrección     |

## Compilar y ejecutar

```bash
flex calc.l
bison -d calc.y
gcc -o calc lex.yy.c calc.tab.c -lfl -lm
echo "/* solo un comentario */" | ./calc
```

**Salida esperada:** sin error (la línea es aceptada silenciosamente).
