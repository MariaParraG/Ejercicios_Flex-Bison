# Ejercicio 3 (Extra crédito) — Operadores AND y OR

## Pregunta

> Agregar operadores binarios `AND` y `OR`. El operador obvio para `OR` es la barra vertical `|`, pero esa ya está en uso como operador unario de valor absoluto. ¿Qué sucede si se usa `|` también como `OR` binario, por ejemplo `exp ABS factor`?

## Análisis del conflicto

La barra `|` en la gramática original es **unaria**: `| expr |`.

Si la reutilizamos como `OR` binario (`expr | expr`), la gramática se vuelve **ambigua**: el parser no puede saber si el `|` que ve abre un valor absoluto o es un OR binario. Esto produce conflictos `shift/reduce` en Bison, y la calculadora puede parsear expresiones incorrectamente.

**Ejemplo problemático:**
```
2 | 3 | 4
```
¿Es `2 OR 3 OR 4`, `|2 OR 3| OR 4`, `2 OR |3 OR 4|`? El parser no puede determinar cuál.

## Solución adoptada

Se usan tokens léxicos distintos:
- `&&` → AND lógico/bitwise
- `||` → OR lógico/bitwise  
- `|expr|` sigue siendo valor absoluto (el scanner reconoce `||` antes que `|` solo)

El scanner debe definir `||` **antes** que `|` para que Flex aplique "maximal munch" correctamente.

## Semántica implementada

| Operador | Operación                   | Ejemplo          |
|----------|-----------------------------|------------------|
| `&&`     | AND bitwise (enteros)       | `5 && 3` → `1`  |
| `\|\|`   | OR bitwise (enteros)        | `5 \|\| 2` → `7`|
| `\|x\|`  | Valor absoluto              | `\|-5\|` → `5`  |

## Archivos

| Archivo  | Descripción                                      |
|----------|--------------------------------------------------|
| `calc.l` | Scanner con `&&` y `\|\|` como tokens separados  |
| `calc.y` | Parser con reglas AND, OR y precedencias         |

## Compilar y ejecutar

```bash
flex calc.l
bison -d calc.y
gcc -o calc lex.yy.c calc.tab.c -lfl -lm
```

## Ejemplos

```
5 && 3      →  = 1
5 || 2      →  = 7
|-5|        →  = 5
5 && 3 || 1 →  = 1  (AND tiene mayor precedencia)
```
