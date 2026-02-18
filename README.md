# Ejercicio 5 — Lenguajes donde Flex no es una buena herramienta

## Pregunta

> ¿Se te ocurren lenguajes para los cuales Flex no sería una buena herramienta para escribir un scanner?

## Análisis

Flex está diseñado para lenguajes cuya tokenización puede describirse con **expresiones regulares** (lenguajes regulares). Cuando la tokenización de un lenguaje requiere capacidades más allá de las expresiones regulares, Flex deja de ser la herramienta adecuada.

## Lenguajes donde Flex no es ideal

### 1. Python (y lenguajes sensibles a la indentación)

Python usa la indentación para delimitar bloques: cada vez que el nivel de indentación aumenta se emite `INDENT`, y cuando disminuye se emiten uno o más tokens `DEDENT`.

**Problema:** para generar DEDENT correctamente hay que mantener una **pila de niveles de indentación**, lo que es estado contextual que va más allá de los autómatas finitos de Flex. Se puede hacer con código C auxiliar en las acciones Flex, pero resulta torpe.

### 2. Lenguajes con strings interpolados (Bash, Ruby, Perl, JS template literals)

```ruby
"Hola #{nombre}, tienes #{edad} años"
```

Dentro de `#{ ... }` puede haber expresiones completas, incluyendo strings anidados. La estructura es **recursiva/anidada**, y los lenguajes regulares no pueden contar anidaciones arbitrarias. Flex puede manejar un nivel de anidación con condiciones de inicio (`%x`), pero varios niveles resultan en código frágil.

### 3. HTML / XML con atributos complejos

El contenido de un atributo puede contener comillas escapadas, referencias a entidades (`&amp;`, `&#x2F;`), y el delimitador puede ser `"` o `'`. Aunque se puede aproximar con Flex, la especificación completa requiere lookahead y manejo de contexto que lo hace poco práctico.

### 4. Markdown y formatos de marcado ligero

Markdown tiene reglas de tokenización dependientes del **contexto** (una `*` es diferente si está al inicio de línea, dentro de código, o en mitad de párrafo). La especificación CommonMark requiere múltiples pasadas y lógica de estado que supera a las expresiones regulares.

### 5. Lenguajes con comentarios anidados (Haskell, Ada, Lua)

Haskell permite comentarios `{- ... {- ... -} ... -}`. Un autómata finito no puede contar niveles de anidación; se necesita al menos un contador (una forma de memoria), lo que equivale a un autómata de pila.

### 6. Lenguajes con datos binarios o longitud embebida

Algunos formatos de serialización (Protocol Buffers binario, BSON, MessagePack) codifican la longitud del siguiente campo en bytes anteriores. Flex trabaja sobre caracteres y no tiene forma de expresar "leer N bytes donde N viene del campo anterior".

## Resumen

| Lenguaje / Formato        | Razón por la que Flex no es ideal                         |
|---------------------------|-----------------------------------------------------------|
| Python                    | Indentación requiere pila de contexto                     |
| Ruby / JS template strings| Interpolación con expresiones anidadas (recursión)        |
| Haskell                   | Comentarios anidados (requiere contador)                  |
| Markdown (CommonMark)     | Tokenización dependiente del contexto global              |
| Formatos binarios         | Longitudes dinámicas, datos no textuales                  |

## Archivo

| Archivo       | Descripción                                                       |
|---------------|-------------------------------------------------------------------|
| `ejemplos.md` | Ejemplos de código en cada lenguaje mostrando la dificultad       |

*(Este ejercicio es teórico; no hay código Flex que resolver.)*
