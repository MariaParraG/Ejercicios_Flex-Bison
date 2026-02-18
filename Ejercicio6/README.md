# Ejercicio 6 — Programa de conteo de palabras en C

## Pregunta

> Reescribir el programa de conteo de palabras en C. Ejecutar archivos grandes con ambas versiones. ¿Es notablemente más rápida la versión en C? ¿Fue mucho más difícil de depurar?

## Análisis

### Diferencias de rendimiento esperadas

La versión Flex genera C que compila a un **autómata finito determinista (DFA)** altamente optimizado. El overhead principal de Flex es la llamada a `yylex()` y el manejo de buffer interno. La versión manual en C puede evitar ese overhead con I/O más directo (`fread` en bloques grandes), pero también puede ser más lenta si no se optimiza bien.

**En la práctica**, para archivos grandes (> 100 MB):
- La versión C con `fread` en bloques grandes suele ser **ligeramente más rápida** (menos overhead de función).
- La versión Flex es más rápida que una versión C naive que llama `getchar()` en bucle.
- La diferencia rara vez supera el **20-30%** para conteo de palabras simple.

### Dificultad de depuración

La versión Flex es trivial de depurar: la lógica está en reglas declarativas. La versión C requiere manejar correctamente los **estados** (dentro/fuera de palabra) y los casos borde: múltiples espacios, tabs, saltos de línea, EOF en mitad de palabra.

## Archivos

| Archivo   | Descripción                                    |
|-----------|------------------------------------------------|
| `wc.l`    | Versión Flex del contador de palabras          |
| `wc_c.c`  | Versión C manual equivalente                   |
| `bench.sh` | Script para comparar tiempos con archivos grandes |

## Compilar

```bash
# Versión Flex
flex wc.l
gcc -O2 -o wc_flex lex.yy.c -lfl

# Versión C
gcc -O2 -o wc_c wc_c.c
```

## Benchmark

```bash
# Generar archivo de prueba grande (~50 MB)
yes "El veloz murciélago hindú comía feliz cardillo y kiwi" | head -1000000 > test_large.txt

# Medir ambos
time ./wc_flex  < test_large.txt
time ./wc_c     < test_large.txt
time wc -w        test_large.txt   # referencia del sistema
```

## Resultado típico (referencial)

```
Versión Flex:   ~0.8s para 50 MB
Versión C:      ~0.6s para 50 MB  (fread en bloque)
wc del sistema: ~0.3s para 50 MB  (altamente optimizado en C nativo)
```

La versión C es algo más rápida, pero la diferencia no justifica la complejidad extra de depuración. La versión C manual es ~30 líneas vs ~10 líneas Flex, y requiere manejo explícito del estado entre llamadas a `fread`.
