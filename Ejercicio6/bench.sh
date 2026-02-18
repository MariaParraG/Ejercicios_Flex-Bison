#!/bin/bash
# bench.sh — Benchmark de versión Flex vs C (Ejercicio 6)
# Uso: ./bench.sh

set -e

echo "=== Compilando versiones ==="
flex wc.l && gcc -O2 -o wc_flex lex.yy.c -lfl && echo "OK: wc_flex"
gcc -O2 -o wc_c wc_c.c && echo "OK: wc_c"

echo ""
echo "=== Generando archivo de prueba grande (~50 MB) ==="
python3 -c "
line = 'El veloz murciélago hindú comía feliz cardillo y kiwi. '
import sys
for _ in range(900000):
    sys.stdout.write(line + '\n')
" > test_large.txt

SIZE=$(du -sh test_large.txt | cut -f1)
echo "Archivo: test_large.txt ($SIZE)"

echo ""
echo "=== Benchmark ==="
echo "--- Versión Flex ---"
time ./wc_flex < test_large.txt

echo ""
echo "--- Versión C (fread) ---"
time ./wc_c test_large.txt

echo ""
echo "--- wc del sistema (referencia) ---"
time wc -lwc test_large.txt

echo ""
echo "Listo. Compara los tiempos de 'real' en cada bloque."
