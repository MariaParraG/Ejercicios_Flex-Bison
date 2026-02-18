# Ejemplos — Lenguajes difíciles para Flex (Ejercicio 5)

## 1. Python — Indentación como token

```python
# Python: la indentación ES parte de la gramática
if x > 0:
    print("positivo")   # INDENT aquí
    print("sigue")      # mismo nivel
print("fuera")          # DEDENT aquí
```

Para emitir INDENT/DEDENT correctamente el scanner necesita
mantener una PILA de niveles. En Flex se requiere código C
extra (no una simple expresión regular):

```c
/* Pseudocódigo de lo que habría que hacer en la acción Flex */
int indent_stack[100];
int stack_top = 0;

/* Al inicio de línea: contar espacios */
/* Si spaces > indent_stack[top]  → emitir INDENT, push */
/* Si spaces < indent_stack[top]  → emitir DEDENT, pop (varias veces) */
/* Si spaces == indent_stack[top] → no emitir nada                    */
```

---

## 2. Ruby — Strings interpolados con anidación

```ruby
nombre = "mundo"
msg = "Hola #{nombre.upcase + "!"}, son las #{Time.now}"
#                                         ^^^
#                          String anidado dentro de la interpolación
```

Un scanner Flex puede abrir `#{` con una condición de inicio `%x`,
pero si dentro hay otro string con interpolación, se necesita
**otro nivel de estado**, y así recursivamente. Los autómatas
finitos no pueden manejar anidación arbitraria.

---

## 3. Haskell — Comentarios anidados

```haskell
{- Comentario exterior
   {- Comentario interior -}
   Esto sigue siendo comentario
-}
```

Para reconocer el cierre correcto hay que contar cuántos `{-`
abiertos hay. Un autómata finito NO puede contar (necesitaría
memoria ilimitada). Se requiere al menos un contador entero.

Flex workaround (funciona pero es frágil):
```flex
%x COMMENT
%%
"{-"          { BEGIN(COMMENT); depth = 1; }
<COMMENT>"{-" { depth++; }
<COMMENT>"-}" { if (--depth == 0) BEGIN(INITIAL); }
<COMMENT>.|\n { /* ignorar */ }
```

---

## 4. Markdown — Contexto global

```markdown
En *este* párrafo `*` es cursiva.

    En bloque de código, *esto* NO es cursiva.

- En una lista
  - sub-ítem (indentación relativa al ítem padre)
```

Para saber si una `*` es cursiva, hay que conocer el contexto:
¿estamos en un bloque de código?, ¿en una lista?, ¿dentro de
un link? Esto requiere estado global que las expresiones regulares
no pueden expresar.

---

## 5. Formato binario con longitud embebida (MessagePack)

```
Byte 0: 0xC5 → tipo "bin16"
Byte 1-2: longitud en big-endian, p.ej. 0x00 0x05 → 5 bytes
Byte 3-7: datos binarios
```

No hay forma de escribir en Flex una expresión regular como
"lee los próximos N bytes, donde N es el valor de los 2 bytes
anteriores". Flex opera carácter a carácter sin memoria entre
tokens, salvo lo que el programador gestione manualmente.
