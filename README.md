# Ejercicio 4 — Scanner manuscrito vs. scanner Flex

## Pregunta

> ¿El scanner escrito a mano del Ejemplo 1-4 reconoce exactamente los mismos tokens que la versión Flex?

## Análisis

### Tokens del Ejemplo 1-4 (Flex)

El scanner Flex de la calculadora reconoce:

| Token   | Patrón Flex                   |
|---------|-------------------------------|
| NUMBER  | `[0-9]+(\.[0-9]+)?`           |
| ADD     | `+`                           |
| SUB     | `-`                           |
| MUL     | `*`                           |
| DIV     | `/`                           |
| ABS     | `\|`                          |
| OP      | `(`                           |
| CP      | `)`                           |
| EOL     | `\n`                          |
| —       | Espacios/tabs ignorados       |
| —       | Comentarios `/* ... */`       |

### Diferencias entre scanner manual y Flex

Un scanner escrito a mano típicamente difiere en los siguientes puntos:

1. **Maximal munch**: Flex siempre toma el lexema más largo posible (`0.5` se lee completo). Un scanner manual puede cometer errores si no implementa correctamente el lookahead.

2. **Números flotantes**: Flex reconoce `[0-9]+(\.[0-9]+)?` en una sola regla. Un scanner manual tiende a leer dígitos y luego verificar si hay un `.`, lo que puede funcionar distinto en casos borde como `.5` (sin dígito inicial — Flex NO lo reconoce con este patrón, el scanner manual podría sí o no dependiendo de la implementación).

3. **Comentarios multilínea**: `/* ... */` en Flex usa una expresión regular compacta. Un scanner manual necesita un estado/bandera explícita para rastrear si está dentro de un comentario, y puede fallar con comentarios anidados o `*/` incrustado en strings.

4. **Caracteres desconocidos**: Flex tiene la regla catch-all `.` que imprime un mensaje. Un scanner manual puede comportarse diferente (ignorar, lanzar excepción, etc.).

5. **EOF**: Flex llama a `yywrap()` al llegar a EOF. Un scanner manual debe manejar EOF explícitamente en cada llamada.

### Conclusión

En términos del conjunto de tokens reconocidos para entradas **válidas y normales**, ambos reconocen los mismos tokens. Las diferencias aparecen en **casos borde**: números sin parte entera (`.5`), entradas malformadas, y manejo de EOF. Flex es más robusto porque su motor de NFA/DFA garantiza maximal munch sistemáticamente.

## Archivo

| Archivo        | Descripción                                     |
|----------------|-------------------------------------------------|
| `handscanner.c` | Scanner manual equivalente al del Ejemplo 1-4  |

## Compilar y ejecutar

```bash
gcc -o handscanner handscanner.c
echo "3 + 4 * 2" | ./handscanner
```
